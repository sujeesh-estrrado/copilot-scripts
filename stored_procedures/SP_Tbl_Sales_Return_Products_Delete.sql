IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Sales_Return_Products_Delete]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Tbl_Sales_Return_Products_Delete]      
 @Sales_Return_Prod_Id bigint      
AS      
DECLARE @intErrorCode INT    
Declare @Product_Id bigint    
Declare @Quantity bigint    
Declare @InvoiceCode varchar(100)    
    
SET @Product_Id=(SELECT Product_Id From Tbl_Inventory_Sales_Products WHERE Inventory_Sales_Product_Id=(SELECT Inventory_Sales_Product_Id From Tbl_Sales_Return_Products Where Sales_Return_Prod_Id=@Sales_Return_Prod_Id))    
SET @Quantity=(SELECT Quantity From Tbl_Inventory_Sales_Products WHERE Inventory_Sales_Product_Id=(SELECT Inventory_Sales_Product_Id From Tbl_Sales_Return_Products Where Sales_Return_Prod_Id=@Sales_Return_Prod_Id))    
SET @InvoiceCode=    
(SELECT Invoice_Code_Prefix+Sales_Return_Code+Invoice_Code_Suffix    
FROM Tbl_Sales_Return s INNER JOIN Tbl_Inventory_Invoice_Code c ON s.Invoice_Code_Id=c.Invoice_Code_Id    
WHERE Sales_Return_Id=(SELECT Sales_Return_Id FROM Tbl_Sales_Return_Products WHERE Sales_Return_Prod_Id=@Sales_Return_Prod_Id))    
    
BEGIN  TRAN      
UPDATE [Tbl_Sales_Return_Products]      
   SET [Sales_Prod_Return_Del_Status] = 1      
 WHERE Sales_Return_Prod_Id=@Sales_Return_Prod_Id      
    
SELECT @intErrorCode = @@ERROR        
    IF (@intErrorCode <> 0) GOTO PROBLEM      
    
  INSERT INTO [Tbl_Product_Stocks]    
           ([Product_Id]    
           ,[InvoiceCode]    
           ,[Product_Stock_DtTime]    
           ,[Product_Current_Stock]    
           ,[Product_Stock_Type]    
           ,[Product_Stock_DelStatus]  
           ,[Product_Stock_Profit_Loss])    
     VALUES    
           (@Product_Id    
           ,@InvoiceCode    
           ,getdate()    
           ,@Quantity    
           ,''CANCEL''    
           ,0  
           ,1)    
    
SELECT @intErrorCode = @@ERROR        
    IF (@intErrorCode <> 0) GOTO PROBLEM       
    
COMMIT TRAN    
    
PROBLEM:        
IF (@intErrorCode <> 0) BEGIN        
PRINT ''Unexpected error occurred!''        
    ROLLBACK TRAN        
END
    ')
END;
