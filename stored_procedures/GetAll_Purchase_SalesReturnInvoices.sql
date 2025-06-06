IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[GetAll_Purchase_SalesReturnInvoices]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[GetAll_Purchase_SalesReturnInvoices]

AS
BEGIN

SELECT     dbo.Tbl_Inventory_Invoice_Code.Invoice_Code_Prefix + CAST(dbo.Tbl_Inventory_Purchase.Inventory_Purchase_Code AS varchar(100)) 
                      + dbo.Tbl_Inventory_Invoice_Code.Invoice_Code_Suffix AS CODE, 0 AS [Type],dbo.Tbl_Inventory_Purchase.Inventory_Purchase_Id AS ID
FROM         dbo.Tbl_Inventory_Purchase INNER JOIN
                      dbo.Tbl_Inventory_Invoice_Code ON dbo.Tbl_Inventory_Purchase.Invoice_Code_ID = dbo.Tbl_Inventory_Invoice_Code.Invoice_Code_Id
WHERE     (dbo.Tbl_Inventory_Invoice_Code.Invoice_Code_Del_Status = 0) AND (dbo.Tbl_Inventory_Purchase.Inventory_Purchase_DelStatus = 0)

UNION

SELECT     dbo.Tbl_Inventory_Invoice_Code.Invoice_Code_Prefix + CAST(dbo.Tbl_Sales_Return.Sales_Return_Code AS varchar(100)) 
                      + dbo.Tbl_Inventory_Invoice_Code.Invoice_Code_Suffix AS CODE, 1 AS [Type], dbo.Tbl_Sales_Return.Sales_Return_Id AS ID
FROM         dbo.Tbl_Sales_Return INNER JOIN
                      dbo.Tbl_Inventory_Invoice_Code ON dbo.Tbl_Sales_Return.Invoice_Code_Id = dbo.Tbl_Inventory_Invoice_Code.Invoice_Code_Id
WHERE     (dbo.Tbl_Inventory_Invoice_Code.Invoice_Code_Del_Status = 0) AND (dbo.Tbl_Sales_Return.Sales_Return_Del_Status = 0)

END
    ')
END
