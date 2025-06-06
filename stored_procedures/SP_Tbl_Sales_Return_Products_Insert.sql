IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Sales_Return_Products_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Sales_Return_Products_Insert]   
        @Inventory_Sales_Product_Id bigint      
        ,@Sales_Return_Id bigint    
        ,@Sales_Prod_Rturn_Quantity int      
        ,@Sales_Prod_Return_price decimal(18,2)      
        ,@Sales_Prod_Return_TotalPrice decimal(18,2)      
        ,@Sales_Prod_Return_Del_Status bit      
        AS      
        DECLARE @PRODUCT_ID bigint    
        DECLARE @INVOICE_CODE varchar(100)    
        DECLARE @intErrorCode INT      
        DECLARE @ID INT      
        
        BEGIN TRAN     
        
        INSERT INTO [Tbl_Sales_Return_Products]      
                   ([Inventory_Sales_Product_Id]      
                   ,[Sales_Return_Id]    
                   ,[Sales_Prod_Rturn_Quantity]      
                   ,[Sales_Prod_Return_price]      
                   ,[Sales_Prod_Return_TotalPrice]      
                   ,[Sales_Prod_Return_Del_Status])      
             VALUES      
                   (@Inventory_Sales_Product_Id      
                   ,@Sales_Return_Id    
                   ,@Sales_Prod_Rturn_Quantity       
                   ,@Sales_Prod_Return_price      
                   ,@Sales_Prod_Return_TotalPrice      
                   ,@Sales_Prod_Return_Del_Status)      
        SET @ID= (SELECT @@IDENTITY)    
      
        SELECT @intErrorCode = @@ERROR      
        IF (@intErrorCode <> 0) GOTO PROBLEM         
        
        
        SET @PRODUCT_ID= (SELECT Product_Id FROM Tbl_Inventory_Sales_Products WHERE  Inventory_Sales_Product_Id=    
        (SELECT Inventory_Sales_Product_Id FROM Tbl_Sales_Return_Products WHERE Sales_Return_Prod_Id=@ID    
        ))    
        
        SET @INVOICE_CODE=(    
        SELECT (Invoice_Code_Prefix+Sales_Return_Code+Invoice_Code_Suffix)   
        FROM Tbl_Sales_Return SR INNER JOIN  
        Tbl_Sales_Return_Products SRP  
        ON SR.Sales_Return_Id = SRP.Sales_Return_Id  
        INNER JOIN Tbl_Inventory_Invoice_Code IC   
        ON SR.Invoice_Code_Id = IC.Invoice_Code_Id  
        WHERE SRP.Sales_Return_Prod_Id = (SELECT Sales_Return_Id FROM     
        Tbl_Sales_Return_Products WHERE Sales_Return_Prod_Id=@ID))  
        
        
        
        INSERT INTO Tbl_Product_Stocks    
                   ([InvoiceCode]    
                   ,[Product_Stock_DtTime]               
                   ,[Product_Stock_Type]    
                   ,[Product_Stock_DelStatus]    
                   ,[Product_Current_Stock]    
                   ,[Product_Id])       
             VALUES     
                  (@INVOICE_CODE,    
             getdate(),    
             ''SALES RETURN'',    
             0,    
             @Sales_Prod_Rturn_Quantity,    
             @PRODUCT_ID    
                   )    
        
        SELECT @intErrorCode = @@ERROR      
        IF (@intErrorCode <> 0) GOTO PROBLEM     
        
        
        COMMIT TRAN      
        
        PROBLEM:      
        IF (@intErrorCode <> 0) BEGIN      
        PRINT ''Unexpected error occurred!''      
            ROLLBACK TRAN     
        
        END
    ')
END
