IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Expense_Head_Select_ByID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Tbl_Expense_Head_Select_ByID]   
 @Expense_Id bigint  
AS  
BEGIN  
SELECT 
(Select dbo.GetInvoiceCodeById_Code(Invoice_Code_Id,Inventory_Invoice_code)) As Inventory_Invoice_code,  
 Expense_Id,Acc_Cat_Id,Expense_Title,Expense_Description,  
Expense_Amount,Expense_Date  
  FROM dbo.Tbl_Expense_Head  
WHERE Expense_Id=@Expense_Id  
END
    ')
END;
