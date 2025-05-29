IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Cash_In_Hand_SelectAll]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Tbl_Cash_In_Hand_SelectAll]                        
AS                        
BEGIN                        
SELECT       
Distinct Cash_Id,                      
(Select dbo.GetInvoiceCodeById_Code(Cash_Invoice_Code_Id,Cash_Invoice_Code)) As Inventory_Invoice_code,                    
Cash_Title,Cash_Description,Cash_Amount,Cash_Date,                
Case                
When Payment_Details_Mode=1 Then Cash_Register_Payee_Name                                       
When Payment_Details_Mode=2 Then Cheque_Register_Payee_Name                                      
When Payment_Details_Mode=3 Then DD_Register_Payee_Name                     
When Payment_Details_Mode=6 Then Bank_Transfer_Payee_Name                                      
Else '''' End AS Payee_Name              
               
  FROM  Tbl_Cash_In_Hand CH               
INNER JOIN Tbl_Payment_Details  p ON p.Payment_Details_Particulars_Id =CH.Cash_Id and  p.Payment_Details_Particulars=''CASH IN HAND''             
LEFT JOIN Tbl_Payment_Cash_Register cr  ON p.Payment_Details_Mode_Id= cr.Cash_Register_Id and Payment_Details_Mode=1               
LEFT JOIN  Tbl_Payment_Cheque_Register chr ON p.Payment_Details_Mode_Id= chr.Cheque_Register_Id   and Payment_Details_Mode=2              
LEFT JOIN  Tbl_Payment_DD_Register dr on p.Payment_Details_Mode_Id=dr.DD_Register_Id    and Payment_Details_Mode=3              
LEFT JOIN  Tbl_Payment_Bank_Transfer bt on p.Payment_Details_Mode_Id=bt.Bank_Transfer_Id    and Payment_Details_Mode=6              
                      
WHERE Cash_Status=0                        
Order by Cash_Date desc,Cash_Id desc          
END
    ')
END;
