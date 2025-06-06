IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Ventorwise_Productlist]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure  [dbo].[Ventorwise_Productlist]
--(@Ventor_id BIGINT)
AS
BEGIN
    

SELECT     Sum( dbo.Tbl_Inventory_Purchase_Products.Quantity) as  Quantity, 
                     
Sum(dbo.Tbl_Inventory_Purchase_Products.Inventory_Purchase_Prod_TotPrice) as [Total Price], 
                      Sum(dbo.Tbl_Inventory_Purchase_Products.Inventory_Purchase_SubTotal) as SubTotal, 
dbo.Tbl_Venders.Vender_Name, dbo.Tbl_Products.Product_Name,dbo.Tbl_Inventory_Purchase_Products.Product_Id,
   dbo.Tbl_Venders.Vender_id
FROM         dbo.Tbl_Inventory_Purchase INNER JOIN
                      dbo.Tbl_Inventory_Purchase_Products ON 
                      dbo.Tbl_Inventory_Purchase.Inventory_Purchase_Id = dbo.Tbl_Inventory_Purchase_Products.Inventory_Purchase_Id
 INNER JOIN
                      dbo.Tbl_Venders ON dbo.Tbl_Inventory_Purchase.Ventor_Id = dbo.Tbl_Venders.Vender_id INNER JOIN
                      dbo.Tbl_Products ON dbo.Tbl_Inventory_Purchase_Products.Product_Id = dbo.Tbl_Products.Product_Id

WHERE     (dbo.Tbl_Venders.Vender_Del_Status = 0) AND (dbo.Tbl_Inventory_Purchase.Inventory_Purchase_DelStatus = 0) AND (dbo.Tbl_Products.Product_Del_Status = 0)
--AND (dbo.Tbl_Venders.Vender_id=@Ventor_id)


group by dbo.Tbl_Venders.Vender_Name, dbo.Tbl_Products.Product_Name,dbo.Tbl_Inventory_Purchase_Products.Product_Id,   dbo.Tbl_Venders.Vender_id
END
    ')
END
