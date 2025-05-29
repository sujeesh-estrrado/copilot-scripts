IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Bank_Transfer_Select_ByID]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[SP_Tbl_Bank_Transfer_Select_ByID]             
 @Bank_Id bigint            
AS            
BEGIN            
SELECT            
(Select dbo.GetInvoiceCodeById_Code(Bank_Invoice_Code_Id,Bank_Invoice_Code)) As Inventory_Invoice_code,                
Bank_Id,Bank_Title,Bank_Description,Bank_Amount,Bank_Date            
     
  FROM Tbl_Bank_Transfer CH      
WHERE Bank_Id=@Bank_Id           
END
    ')
END;
