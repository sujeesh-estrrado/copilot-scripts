IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Inventory_Purchase_SelectAllPurchaseOrderCOMPLETE_By_Vendor_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Tbl_Inventory_Purchase_SelectAllPurchaseOrderCOMPLETE_By_Vendor_Id]
(
@Vendor_Id bigint
)                    
AS                    
BEGIN                    
              
              
SELECT     IP.Inventory_Purchase_Id, IP.Ventor_Id, v.Vender_Name, IP.Inventory_Purchase_CreatedDate, 
           IP.Inventory_Purchase_LastUpdatedDate,               
           IP.Inventory_Purchase_DelStatus, IP.Invoice_Code_ID,IP.Order_Status,               
          dbo.Tbl_Inventory_Invoice_Code.Invoice_Code_Prefix + IP.Inventory_Purchase_Code + dbo.Tbl_Inventory_Invoice_Code.Invoice_Code_Suffix AS Inventory_Purchase_Code             
,         CASE IP.Store_Category    WHEN 1  THEN ''ASSET'' ELSE ''GENERAL'' END  AS [Category]          
          
           
FROM         dbo.Tbl_Inventory_Purchase AS IP INNER JOIN              
                      dbo.Tbl_Venders AS v ON IP.Ventor_Id = v.Vender_id INNER JOIN              
                      dbo.Tbl_Inventory_Invoice_Code ON IP.Invoice_Code_ID = dbo.Tbl_Inventory_Invoice_Code.Invoice_Code_Id              
WHERE     (IP.Inventory_Purchase_DelStatus = 0 and IP.Order_Status=''ORDER COMPLETE'') and IP.Ventor_Id=@Vendor_Id                
END
    ')
END
