IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Inventory_Sales_GetLatestInvoiceNo]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[SP_Tbl_Inventory_Sales_GetLatestInvoiceNo]            
          
AS           
begin          
          
--DECLARE @SalesCode varchar(100),@InvoiceCodeStartNo varchar(100),@code varchar(100),@Invoice_Code_Id bigint,@sales_code_id bigint
--set @Invoice_Code_Id=(Select Invoice_Code_Id From Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''''Sales'''' and Invoice_Code_Current_Status=1 and getdate() between Invoice_Code_From_Date and Invoice_Code_To_Date and Invoice_Code_Del_Status=0)           
--set @sales_code_id=(Select top 1 Invoice_Code_Id From Tbl_Inventory_Sales Order By Inventory_Sales_Id DESC)
--if(@Invoice_Code_Id=@sales_code_id)
--Begin
--set @code=(Select top 1 Inventory_Invoice_code From Tbl_Inventory_Sales Order By Inventory_Sales_Id DESC)+1                
--End
--Else
--Begin
--set @code=(Select Invoice_Code_StartNo From Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''''Sales'''' and Invoice_Code_Current_Status=1 and getdate() between Invoice_Code_From_Date and Invoice_Code_To_Date and Invoice_Code_Del_Status=0)    
--End
--SELECT  Invoice_Code_Prefix+@code+Invoice_Code_Suffix AS Invoice_Code     
--FROM Tbl_Inventory_Invoice_Code Where Invoice_Code_Id=@Invoice_Code_Id    

Select Invoice_Code From [dbo].[GetInvoiceCodeByType](''Sales'')

end
    ')
END
