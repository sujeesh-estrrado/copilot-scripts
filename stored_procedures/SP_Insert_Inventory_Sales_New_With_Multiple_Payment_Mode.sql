IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Inventory_Sales_New_With_Multiple_Payment_Mode]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[SP_Insert_Inventory_Sales_New_With_Multiple_Payment_Mode]                                  
    (                                  
        @Inventory_Customer_Id BIGINT,                                  
        @Inventory_Sales_Quote_DtTime DATETIME,                                  
        @Inventory_Sales_Order_DtTime DATETIME,                                  
        @Inventory_Sales_Status BIT,                                
        @ProductXml XML,                  
        @PaymentXML XML,          
        @empStud VARCHAR(50),          
        @Payment_Due_Date DATETIME,          
        @Grand_Total DECIMAL(18,2),          
        @Payment_Amount DECIMAL(18,2)          
    )                                  
    AS                                  
    BEGIN
        DECLARE @intErrorCode INT                                  
        DECLARE @id BIGINT                                  
        DECLARE @Invoice_Code_Id BIGINT
        DECLARE @Invoice_Code_Prefix VARCHAR(100),                              
                @Invoice_Code_Suffix VARCHAR(100),
                @code VARCHAR(100)  
        
        -- Fetch invoice code details
        SET @Invoice_Code_Id = (SELECT Invoice_Code_Id FROM [dbo].[GetInvoiceCodeByType](''Sales''))
        SET @code = (SELECT Code FROM [dbo].[GetInvoiceCodeByType](''Sales''))
        SET @Invoice_Code_Prefix = (SELECT Invoice_Code_Prefix FROM Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''Sales'' AND Invoice_Code_Current_Status=1)
        SET @Invoice_Code_Suffix = (SELECT Invoice_Code_Suffix FROM Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''Sales'' AND Invoice_Code_Current_Status=1)
        
        BEGIN TRANSACTION                                  
        
        -- Insert into Sales Table
        INSERT INTO Tbl_Inventory_Sales
        (Inventory_Customer_Id, Inventory_Invoice_code, Invoice_Code_Id, Inventory_Sales_Quote_DtTime, 
         Inventory_Sales_Order_DtTime, Inventory_Sales_Status, empStud)
        VALUES
        (@Inventory_Customer_Id, @code, @Invoice_Code_Id, @Inventory_Sales_Quote_DtTime, 
         @Inventory_Sales_Order_DtTime, @Inventory_Sales_Status, @empStud)
        
        SET @id = SCOPE_IDENTITY()
        SET @intErrorCode = @@ERROR
        IF @intErrorCode <> 0 GOTO ERROR_HANDLER
        
        -- Insert into Sales Products Table
        INSERT INTO Tbl_Inventory_Sales_Products
        ([Inventory_Sales_Id], [Inventory_Sales_Status], [Product_Id], [Quantity], [Units_id],
         [Inventory_Sales_Tax_Amount], [Inventory_Sales_Discount], [Inventory_Sales_SubTotal],
         [Inventory_Sales_Discount_Type], [Inventory_Sales_UnitPrice])
        SELECT 
            @id, 0, 
            M.Item.query(''./Product_Id'').value(''.'', ''BIGINT''), 
            M.Item.query(''./Quantity'').value(''.'', ''DECIMAL(18,2)''), 
            M.Item.query(''./Units_id'').value(''.'', ''BIGINT''),
            M.Item.query(''./Inventory_Sales_Tax_Amount'').value(''.'', ''DECIMAL(18,2)''), 
            M.Item.query(''./Inventory_Sales_Discount'').value(''.'', ''DECIMAL(18,2)''), 
            M.Item.query(''./Inventory_Sales_SubTotal'').value(''.'', ''DECIMAL(18,2)''), 
            M.Item.query(''./Inventory_Sales_Discount_Type'').value(''.'', ''VARCHAR(50)''), 
            M.Item.query(''./Inventory_Sales_UnitPrice'').value(''.'', ''DECIMAL(18,2)'') 
        FROM @ProductXml.nodes(''/DocumentElement/Products'') AS M(Item)
        
        SET @intErrorCode = @@ERROR
        IF @intErrorCode <> 0 GOTO ERROR_HANDLER

        -- Insert into Product Stocks
        INSERT INTO Tbl_Product_Stocks
        ([InvoiceCode], [Product_Stock_DtTime], [Product_Stock_Type], [Product_Stock_DelStatus],
         [Product_Stock_Profit_Loss], [Product_Current_Stock], [Product_Id], [Product_Stock_IsDamaged], [Product_Stock_Total_Price])
        SELECT 
            @Invoice_Code_Prefix + @code + @Invoice_Code_Suffix, GETDATE(), ''SALES'', 0, 1,
            M.Item.query(''./Quantity'').value(''.'', ''DECIMAL(18,2)''), 
            M.Item.query(''./Product_Id'').value(''.'', ''BIGINT''), 
            M.Item.query(''./IsDamage'').value(''.'', ''BIT''), 
            M.Item.query(''./Inventory_Sales_SubTotal'').value(''.'', ''DECIMAL(18,2)'') 
        FROM @ProductXml.nodes(''/DocumentElement/Products'') AS M(Item)

        SET @intErrorCode = @@ERROR
        IF @intErrorCode <> 0 GOTO ERROR_HANDLER
        
        -- Insert Payment Approval
        DECLARE @ApprovalId BIGINT
        INSERT INTO [Tbl_Payment_Approval_List]
        ([Approval_Date], [Approval_Due_Date], [Approval_Total_Amount], 
         [Approval_Balance_Amount], [Approval_Status], [Approval_Del_Status])
        VALUES
        (GETDATE(), @Payment_Due_Date, @Grand_Total, @Grand_Total - @Payment_Amount, 0, 0)
        
        SET @ApprovalId = SCOPE_IDENTITY()
        SET @intErrorCode = @@ERROR
        IF @intErrorCode <> 0 GOTO ERROR_HANDLER

        -- Insert multiple payment mode details
        DECLARE @Payment_Mode INT, 
                @Payee_Name VARCHAR(200), 
                @Payment_No VARCHAR(200), 
                @Payment_Date DATETIME, 
                @Payment_AccountNo VARCHAR(150), 
                @Bank_Name VARCHAR(100), 
                @Bank_Address VARCHAR(300), 
                @PM DECIMAL(18,2), 
                @Coupon_Code VARCHAR(50), 
                @Coupon_Amount DECIMAL(18,2), 
                @Expiry_Date DATETIME,
                @VendorId BIGINT,
                @Bank_Transfer_To_Which_Account VARCHAR(50), 
                @Bank_Transfer_From_Which_Acount VARCHAR(50), 
                @Bank_Transfer_Payment_Mode VARCHAR(50), 
                @Bank_Transfer_Date DATETIME, 
                @Bank_Transfer_Remarks VARCHAR(50), 
                @ddwhichaccount VARCHAR(50)

        DECLARE cur1 CURSOR LOCAL FAST_FORWARD FOR
        SELECT 
            M.Item.query(''./Payment_Mode'').value(''.'', ''INT''), 
            M.Item.query(''./Payment_Amount'').value(''.'', ''DECIMAL(18,2)''), 
            M.Item.query(''./Payee_Name'').value(''.'', ''VARCHAR(200)''), 
            CAST(M.Item.query(''./Payment_Date'').value(''.'', ''VARCHAR(10)'') AS DATETIME), 
            M.Item.query(''./Payment_No'').value(''.'', ''VARCHAR(200)''), 
            M.Item.query(''./Payment_AccountNo'').value(''.'', ''VARCHAR(150)''), 
            M.Item.query(''./Bank_Name'').value(''.'', ''VARCHAR(100)''), 
            M.Item.query(''./Bank_Address'').value(''.'', ''VARCHAR(300)''), 
            M.Item.query(''./Coupon_Code'').value(''.'', ''VARCHAR(50)''), 
            M.Item.query(''./Coupon_Amount'').value(''.'', ''DECIMAL(18,2)'') 
        FROM @PaymentXML.nodes(''/DocumentElement/Payment'') AS M(Item)

        OPEN cur1
        FETCH NEXT FROM cur1 INTO @Payment_Mode, @PM, @Payee_Name, @Payment_Date, @Payment_No, @Payment_AccountNo, @Bank_Name, @Bank_Address, @Coupon_Code, @Coupon_Amount
        
        CLOSE cur1
        DEALLOCATE cur1

        COMMIT TRANSACTION
        RETURN
        
        ERROR_HANDLER:
        ROLLBACK TRANSACTION
        PRINT ''Unexpected error occurred!''
    END
    ');
END;
