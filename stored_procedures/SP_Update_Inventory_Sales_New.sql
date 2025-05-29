IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Inventory_Sales_New]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Update_Inventory_Sales_New]                              
(                  
    @Inventory_Sales_Id BIGINT,                      
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
DECLARE @intErrorCode INT                            
DECLARE @XML AS XML                              
DECLARE @id BIGINT                              
DECLARE @Quantity FLOAT      
DECLARE @PXML AS XML                              
                          
DECLARE @InventorySalesCode VARCHAR(100),                          
        @InvoiceCodeStartNo VARCHAR(100),                          
        @code VARCHAR(100),                          
        @Invoice_Code_Id BIGINT,                          
        @Invoice_Code_Prefix VARCHAR(100),                          
        @Invoice_Code_Suffix VARCHAR(100)                          
                          
SET @InventorySalesCode = (SELECT TOP 1 Inventory_Invoice_code FROM Tbl_Inventory_Sales ORDER BY Inventory_Sales_Id DESC)                              
SET @InvoiceCodeStartNo = (SELECT Invoice_Code_StartNo FROM Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''Sales'' AND Invoice_Code_Current_Status=1)                               
SET @code = ISNULL(@InventorySalesCode+1,@InvoiceCodeStartNo)                              
SET @Invoice_Code_Id = (SELECT Invoice_Code_Id FROM Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''Sales'' AND Invoice_Code_Current_Status=1)                               
SET @Invoice_Code_Prefix = (SELECT Invoice_Code_Prefix FROM Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''Sales'' AND Invoice_Code_Current_Status=1)                           
SET @Invoice_Code_Suffix = (SELECT Invoice_Code_Suffix FROM Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''Sales'' AND Invoice_Code_Current_Status=1)                           
                           
BEGIN TRAN                

-- Mark previous sales record as deleted            
UPDATE Tbl_Inventory_Sales 
SET Inventory_Del_Status = 1 
WHERE Inventory_Sales_Id = @Inventory_Sales_Id                      

-- Insert new sales record
INSERT INTO Tbl_Inventory_Sales                                
(Inventory_Customer_Id, Inventory_Invoice_code, Invoice_Code_Id, Inventory_Sales_Quote_DtTime, 
Inventory_Sales_Order_DtTime, Inventory_Sales_Status, empStud)                                    
VALUES(                                
    @Inventory_Customer_Id,                                
    @code,                                
    @Invoice_Code_Id,                                
    @Inventory_Sales_Quote_DtTime,                                
    @Inventory_Sales_Order_DtTime,                    
    @Inventory_Sales_Status, 
    @empStud
)                                     
                     
PRINT 1                             
SET @id = (SELECT @@IDENTITY)                                     
                            
SELECT @intErrorCode = @@ERROR                            
IF (@intErrorCode <> 0) GOTO PROBLEM                 

-- Mark previous products as deleted            
UPDATE Tbl_Inventory_Sales_Products 
SET Inventory_Sales_Status = 1 
WHERE Inventory_Sales_Id = @Inventory_Sales_Id                        
                              
SELECT @XML = @ProductXml    

-- Insert products into sales
INSERT INTO Tbl_Inventory_Sales_Products                                    
(Inventory_Sales_Id, Inventory_Sales_Status, Product_Id, Quantity, Units_id, 
Inventory_Sales_Tax_Amount, Inventory_Sales_Discount, Inventory_Sales_SubTotal, 
Inventory_Sales_Discount_Type, Inventory_Sales_UnitPrice)                                    
SELECT 
    @id AS Inventory_Sales_Id,                                    
    0 AS Inventory_Sales_Status,                        
    M.Item.query(''./Product_Id'').value(''.'',''BIGINT'') AS Product_Id,                     
    M.Item.query(''./Quantity'').value(''.'',''INT'') AS Quantity,                
    M.Item.query(''./Units_id'').value(''.'',''BIGINT'') AS Units_id,                          
    M.Item.query(''./Inventory_Sales_Tax_Amount'').value(''.'',''DECIMAL(18,2)'') AS Inventory_Sales_Tax_Amount,                  
    M.Item.query(''./Inventory_Sales_Discount'').value(''.'',''DECIMAL(18,2)'') AS Inventory_Sales_Discount,                    
    M.Item.query(''./Inventory_Sales_SubTotal'').value(''.'',''DECIMAL(18,2)'') AS Inventory_Sales_SubTotal,                    
    M.Item.query(''./Inventory_Sales_Discount_Type'').value(''.'',''VARCHAR(50)'') AS Inventory_Sales_Discount_Type, 
    M.Item.query(''./Inventory_Sales_UnitPrice'').value(''.'',''DECIMAL(18,2)'') AS Inventory_Sales_UnitPrice                    
FROM @XML.nodes(''/DocumentElement/Products'') AS M(Item)                                   

SELECT @intErrorCode = @@ERROR                                  
IF (@intErrorCode <> 0) GOTO PROBLEM                           

PRINT 2                                    

-- Handle payment details
EXEC SP_Cancel_Payment_Details ''SALES'', @Inventory_Sales_Id            

SELECT @intErrorCode = @@ERROR                            
IF (@intErrorCode <> 0) GOTO PROBLEM               

-- Insert into payment approval
DECLARE @ApprovalId BIGINT              
INSERT INTO [Tbl_Payment_Approval_List]                    
(Approval_Date, Approval_Due_Date, Approval_Total_Amount, Approval_Balance_Amount, Approval_Status, Approval_Del_Status)                    
VALUES                    
(GETDATE(), @Payment_Due_Date, @Grand_Total, @Grand_Total - @Payment_Amount, 0, 0)                    

SET @ApprovalId = (SELECT @@IDENTITY)                    
PRINT 3            

SELECT @intErrorCode = @@ERROR                            
IF (@intErrorCode <> 0) GOTO PROBLEM               

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
        @VendorId BIGINT           

SELECT @PXML = @PaymentXML              
DECLARE cur1 CURSOR LOCAL FAST_FORWARD FOR            
SELECT 
    M.Item.query(''./Payment_Mode'').value(''.'',''INT'') AS Payment_Mode,            
    M.Item.query(''./Payment_Amount'').value(''.'',''DECIMAL(18,2)'') AS Payment_Amount,            
    M.Item.query(''./Payee_Name'').value(''.'',''VARCHAR(200)'') AS Payee_Name,            
    CAST(M.Item.query(''./Payment_Date'').value(''.'',''VARCHAR(10)'') AS DATETIME) AS Payment_Date,            
    M.Item.query(''./Payment_No'').value(''.'',''VARCHAR(200)'') AS Payment_No,            
    M.Item.query(''./Payment_AccountNo'').value(''.'',''VARCHAR(150)'') AS Payment_AccountNo            
FROM @PXML.nodes(''/DocumentElement/Payment'') AS M(Item)    

OPEN cur1            
WHILE 1 = 1            
BEGIN            
    FETCH cur1 INTO @Payment_Mode, @PM, @Payee_Name, @Payment_Date, @Payment_No, @Payment_AccountNo            
    IF @@FETCH_STATUS <> 0 BREAK            
    EXEC SP_Tbl_Payment_Details_Insert_New @ApprovalId, @Payment_Mode, ''Sales'', @id, 1, @PM, @Payee_Name, @Payment_Date, @Payment_No, @Payment_AccountNo
    PRINT 4                    
END            

CLOSE cur1            
DEALLOCATE cur1            

COMMIT TRAN                                  
RETURN

PROBLEM:                                  
IF (@intErrorCode <> 0) BEGIN                                  
    PRINT ''Unexpected error occurred!''                           
    ROLLBACK TRAN                                  
END
');
END;
