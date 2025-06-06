IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_PurchaseReport]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure  [dbo].[Get_PurchaseReport]
(@Inventory_Purchase_Id BIGINT)
AS
BEGIN
    
(SELECT     dbo.Tbl_Inventory_Purchase.Inventory_Purchase_Id, dbo.Tbl_Venders.Vender_id, dbo.Tbl_Venders.Vender_Name, dbo.Tbl_Inventory_Purchase.Invoice_Code_ID, 
                      dbo.Tbl_Inventory_Invoice_Code.Invoice_Code_Prefix + dbo.Tbl_Inventory_Purchase.Inventory_Purchase_Code + dbo.Tbl_Inventory_Invoice_Code.Invoice_Code_Suffix
                       AS Invoice_Code, dbo.Tbl_Inventory_Purchase_Products.Inventory_Purchase_Prod_Id AS Product_Id, dbo.Tbl_Products.Product_Name, 
                      dbo.Tbl_Inventory_Purchase_Products.Quantity, dbo.Tbl_Product_Units.Units_id, dbo.Tbl_Product_Units.Units_Name, 
                      dbo.Tbl_Inventory_Purchase_Products.Inventory_Purchase_Prod_TotPrice, dbo.Tbl_Inventory_Purchase_Products.Inventory_Purchase_TaxAmount, 
                      dbo.Tbl_Inventory_Purchase_Products.Inventory_Purchase_Discounts, dbo.Tbl_Inventory_Purchase_Products.Inventory_Purchase_SubTotal,
                         dbo.Tbl_Inventory_Purchase.Inventory_Purchase_CreatedDate

FROM         dbo.Tbl_Inventory_Purchase INNER JOIN
                      dbo.Tbl_Venders ON dbo.Tbl_Inventory_Purchase.Ventor_Id = dbo.Tbl_Venders.Vender_id INNER JOIN
                      dbo.Tbl_Product_Units INNER JOIN
                      dbo.Tbl_Products ON dbo.Tbl_Product_Units.Units_id = dbo.Tbl_Products.Product_Units INNER JOIN
                      dbo.Tbl_Inventory_Purchase_Products ON dbo.Tbl_Products.Product_Id = dbo.Tbl_Inventory_Purchase_Products.Product_Id ON 
                      dbo.Tbl_Inventory_Purchase.Inventory_Purchase_Id = dbo.Tbl_Inventory_Purchase_Products.Inventory_Purchase_Id INNER JOIN
                      dbo.Tbl_Inventory_Invoice_Code ON dbo.Tbl_Inventory_Purchase.Invoice_Code_ID = dbo.Tbl_Inventory_Invoice_Code.Invoice_Code_Id
WHERE  dbo.Tbl_Inventory_Purchase.Inventory_Purchase_Id=@Inventory_Purchase_Id

UNION

SELECT     dbo.Tbl_Inventory_Purchase.Inventory_Purchase_Id, dbo.Tbl_Venders.Vender_id, dbo.Tbl_Venders.Vender_Name, dbo.Tbl_Inventory_Purchase.Invoice_Code_ID, 
                      dbo.Tbl_Inventory_Invoice_Code.Invoice_Code_Prefix + dbo.Tbl_Inventory_Purchase.Inventory_Purchase_Code + dbo.Tbl_Inventory_Invoice_Code.Invoice_Code_Suffix
                       AS Invoice_Code, dbo.Tbl_Asset_Purchase_Products.Asset_Purchase_Prod_ID AS Product_Id, dbo.Tbl_Products.Product_Name, dbo.Tbl_Asset_Purchase_Products.Quantity, 
                      dbo.Tbl_Product_Units.Units_id, dbo.Tbl_Product_Units.Units_Name, dbo.Tbl_Asset_Purchase_Products.Inventory_Purchase_Prod_TotPrice, 
                      dbo.Tbl_Asset_Purchase_Products.Inventory_Purchase_TaxAmount, dbo.Tbl_Asset_Purchase_Products.Inventory_Purchase_Discounts, 
                      dbo.Tbl_Asset_Purchase_Products.Inventory_Purchase_SubTotal,
                     dbo.Tbl_Inventory_Purchase.Inventory_Purchase_CreatedDate

FROM         dbo.Tbl_Inventory_Purchase INNER JOIN
                      dbo.Tbl_Venders ON dbo.Tbl_Inventory_Purchase.Ventor_Id = dbo.Tbl_Venders.Vender_id INNER JOIN
                      dbo.Tbl_Inventory_Invoice_Code ON dbo.Tbl_Inventory_Purchase.Invoice_Code_ID = dbo.Tbl_Inventory_Invoice_Code.Invoice_Code_Id INNER JOIN
                      dbo.Tbl_Asset_Purchase_Products ON dbo.Tbl_Inventory_Purchase.Inventory_Purchase_Id = dbo.Tbl_Asset_Purchase_Products.Inventory_Purchase_Id INNER JOIN
                      dbo.Tbl_Product_Units INNER JOIN
                      dbo.Tbl_Products ON dbo.Tbl_Product_Units.Units_id = dbo.Tbl_Products.Product_Units ON 
                      dbo.Tbl_Asset_Purchase_Products.Product_Id = dbo.Tbl_Products.Product_Id 
WHERE  dbo.Tbl_Inventory_Purchase.Inventory_Purchase_Id=@Inventory_Purchase_Id)




END
    ')
END
