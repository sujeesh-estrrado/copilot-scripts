IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Income_Head_SelectAll]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Tbl_Income_Head_SelectAll]              
AS              
BEGIN              
SELECT             
(Select dbo.GetInvoiceCodeById_Code(Invoice_Code_Id,Inventory_Invoice_code)) As Inventory_Invoice_code,          
Income_Id,Acc_Cat_Id,Income_Title,Income_Description,Income_Amount,Income_Date,        
(Select  Acc_Cat_Name from  Tbl_Income_Expense_Category A  where  A.Acc_Cat_Id =IH.Acc_Cat_Id) as Head,             
Case              
When Payment_Details_Mode=1 Then Cash_Register_Payee_Name                                     
When Payment_Details_Mode=2 Then Cheque_Register_Payee_Name                                    
When Payment_Details_Mode=3 Then DD_Register_Payee_Name                   
When Payment_Details_Mode=6 Then Bank_Transfer_Payee_Name                                    
Else '''' End AS Payee_Name,            
Case              
When Payment_Details_Mode=1 Then ''Cash''                                     
When Payment_Details_Mode=2 Then ''Cheque''                                    
When Payment_Details_Mode=3 Then ''DD''                   
When Payment_Details_Mode=6 Then ''Bank Transfer''                                    
Else '''' End AS Payment_Mode                                    
             
  FROM  Tbl_Income_Head IH             
INNER JOIN Tbl_Payment_Details  p ON p.Payment_Details_Particulars_Id =IH.Income_Id and  p.Payment_Details_Particulars=''INCOME''           
LEFT JOIN Tbl_Payment_Cash_Register cr  ON p.Payment_Details_Mode_Id= cr.Cash_Register_Id and Payment_Details_Mode=1             
LEFT JOIN  Tbl_Payment_Cheque_Register chr ON p.Payment_Details_Mode_Id= chr.Cheque_Register_Id   and Payment_Details_Mode=2            
LEFT JOIN  Tbl_Payment_DD_Register dr on p.Payment_Details_Mode_Id=dr.DD_Register_Id    and Payment_Details_Mode=3            
LEFT JOIN  Tbl_Payment_Bank_Transfer bt on p.Payment_Details_Mode_Id=bt.Bank_Transfer_Id    and Payment_Details_Mode=6            
                    
WHERE Income_Status=0                      
Order by Income_Date desc,Income_Id desc     
END

   ')
END;
