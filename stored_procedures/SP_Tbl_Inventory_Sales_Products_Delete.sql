IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Inventory_Sales_Products_Delete]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Inventory_Sales_Products_Delete]      
        @Inventory_Sales_Product_Id bigint      
        AS      
        BEGIN
            DECLARE @intErrorCode INT    
            DECLARE @Product_Id bigint    
            DECLARE @Quantity bigint    
            DECLARE @InvoiceCode varchar(100)    

            SET @Product_Id = (
                SELECT Product_Id 
                FROM Tbl_Inventory_Sales_Products 
                WHERE Inventory_Sales_Product_Id = @Inventory_Sales_Product_Id
            )    

            SET @Quantity = (
                SELECT Quantity 
                FROM Tbl_Inventory_Sales_Products 
                WHERE Inventory_Sales_Product_Id = @Inventory_Sales_Product_Id
            )    

            SET @InvoiceCode = (
                SELECT Invoice_Code_Prefix + Inventory_Invoice_code + Invoice_Code_Suffix    
                FROM Tbl_Inventory_Sales s 
                INNER JOIN Tbl_Inventory_Invoice_Code c 
                    ON s.Invoice_Code_Id = c.Invoice_Code_Id    
                WHERE Inventory_Sales_Id = (
                    SELECT Inventory_Sales_Id 
                    FROM Tbl_Inventory_Sales_Products 
                    WHERE Inventory_Sales_Product_Id = @Inventory_Sales_Product_Id
                )
            )    

            BEGIN TRAN    

            UPDATE Tbl_Inventory_Sales_Products      
            SET Inventory_Sales_Status = 1      
            WHERE Inventory_Sales_Product_Id = @Inventory_Sales_Product_Id    

            SELECT @intErrorCode = @@ERROR        
            IF (@intErrorCode <> 0) GOTO PROBLEM      

            INSERT INTO Tbl_Product_Stocks    
                (Product_Id, InvoiceCode, Product_Stock_DtTime, Product_Current_Stock, 
                 Product_Stock_Type, Product_Stock_DelStatus, Product_Stock_Profit_Loss)    
            VALUES    
                (@Product_Id, @InvoiceCode, GETDATE(), @Quantity, ''CANCEL'', 0, 0)    

            SELECT @intErrorCode = @@ERROR        
            IF (@intErrorCode <> 0) GOTO PROBLEM        

            COMMIT TRAN    

            PROBLEM:        
            IF (@intErrorCode <> 0) 
            BEGIN        
                PRINT ''Unexpected error occurred!''        
                ROLLBACK TRAN        
            END
        END
    ')
END
