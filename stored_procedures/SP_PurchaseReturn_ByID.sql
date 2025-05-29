IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_PurchaseReturn_ByID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_PurchaseReturn_ByID] (@Purchase_return_Id bigint)     
    
AS    
    
BEGIN    
    
SELECT     dbo.Tbl_Purchase_Return.Purchase_return_Id,     
                      dbo.Tbl_Inventory_Invoice_Code.Invoice_Code_Prefix + CAST(dbo.Tbl_Purchase_Return.Purchase_Return_Code AS varchar(100))     
                      + dbo.Tbl_Inventory_Invoice_Code.Invoice_Code_Suffix AS Invoice_Code, dbo.Tbl_Purchase_Return.Inventory_Purchase_Id,     
                      dbo.Tbl_Purchase_Return.Purchase_Return_Comment, dbo.Tbl_Purchase_Return.Inventory_Purchase_Code,     
                      dbo.Tbl_Purchase_Return.Purchase_Return_CreatedDate, dbo.Tbl_Purchase_Return.Purchase_Return_LastUpdatedDate,     
                      dbo.Tbl_Purchase_Return_Products.Product_Id, dbo.Tbl_Purchase_Return_Products.Return_Product_Quantity,     
                      dbo.Tbl_Purchase_Return_Products.Return_Product_Price, dbo.Tbl_Purchase_Return_Products.Return_Product_TotalPrice, dbo.Tbl_Products.Product_Name,     
                      dbo.Tbl_Purchase_Return_Products.UnitID ,Tbl_Purchase_Return_Products.Inventory_Purchase_Prod_Id,
                      I.*   
FROM         dbo.Tbl_Purchase_Return INNER JOIN    
                      dbo.Tbl_Purchase_Return_Products ON dbo.Tbl_Purchase_Return.Purchase_return_Id = dbo.Tbl_Purchase_Return_Products.Purchase_return_Id INNER JOIN    
                      dbo.Tbl_Inventory_Invoice_Code ON dbo.Tbl_Purchase_Return.Invoice_Code_Id = dbo.Tbl_Inventory_Invoice_Code.Invoice_Code_Id INNER JOIN    
                      dbo.Tbl_Products ON dbo.Tbl_Purchase_Return_Products.Product_Id = dbo.Tbl_Products.Product_Id    
                      inner join dbo.Tbl_Inventory_Purchase I on I.Inventory_Purchase_Id=dbo.Tbl_Purchase_Return.Inventory_Purchase_Id  
WHERE     (dbo.Tbl_Purchase_Return.Purchase_Return_DelStatus = 0) AND (dbo.Tbl_Products.Product_Del_Status = 0) AND     
                      (dbo.Tbl_Inventory_Invoice_Code.Invoice_Code_Del_Status = 0) AND (dbo.Tbl_Purchase_Return.Purchase_return_Id = @Purchase_return_Id)    
       
END
');
END;