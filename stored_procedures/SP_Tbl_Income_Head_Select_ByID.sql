IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Income_Head_Select_ByID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Tbl_Income_Head_Select_ByID]   
 @Income_Id bigint  
AS  
BEGIN  
SELECT  
(Select dbo.GetInvoiceCodeById_Code(Invoice_Code_Id,Inventory_Invoice_code)) As Inventory_Invoice_code,
Income_Id,Acc_Cat_Id,Income_Title,Income_Description,  
Income_Amount,Income_Date  
  FROM dbo.Tbl_Income_Head  
WHERE Income_Id=@Income_Id  
END

    ')
END;
