IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_All_PurchaseReturn_By_Inventory_Purchase_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
      CREATE procedure [dbo].[SP_Get_All_PurchaseReturn_By_Inventory_Purchase_Id]      
      
(    
@Inventory_Purchase_Id bigint    
)    
AS      
      
BEGIN      
      
SELECT     dbo.Tbl_Purchase_Return.Purchase_return_Id,dbo.Tbl_Purchase_Return.Inventory_Purchase_Id,dbo.Tbl_Inventory_Invoice_Code.Invoice_Code_Prefix + CAST(dbo.Tbl_Purchase_Return.Purchase_Return_Code AS varchar(100))       
                      + dbo.Tbl_Inventory_Invoice_Code.Invoice_Code_Suffix AS [Invoice Code], dbo.Tbl_Products.Product_Name,       
                      dbo.Tbl_Purchase_Return_Products.Return_Product_Quantity as Quantity,  dbo.Tbl_Purchase_Return_Products.Return_Product_TotalPrice AS SubTotal,       
                      dbo.Tbl_Purchase_Return.Purchase_Return_CreatedDate as [Date]      
FROM         dbo.Tbl_Products 
--INNER JOIN      
--                      dbo.Tbl_Product_Units ON dbo.Tbl_Products.Product_Units = dbo.Tbl_Product_Units.Units_id 
INNER JOIN      
                      dbo.Tbl_Purchase_Return INNER JOIN      
                      dbo.Tbl_Purchase_Return_Products ON dbo.Tbl_Purchase_Return.Purchase_return_Id = dbo.Tbl_Purchase_Return_Products.Purchase_return_Id INNER JOIN      
                      dbo.Tbl_Inventory_Invoice_Code ON dbo.Tbl_Purchase_Return.Invoice_Code_Id = dbo.Tbl_Inventory_Invoice_Code.Invoice_Code_Id ON       
                      dbo.Tbl_Products.Product_Id = dbo.Tbl_Purchase_Return_Products.Product_Id     
where  dbo.Tbl_Purchase_Return.Inventory_Purchase_Id=@Inventory_Purchase_Id    
      
END 
    ')
END
