IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Bank_Transfer_SelectAll]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Tbl_Bank_Transfer_SelectAll]                              
AS                              
BEGIN                              
SELECT          
Distinct Bank_Id,                             
(Select dbo.GetInvoiceCodeById_Code(Bank_Invoice_Code_Id,Bank_Invoice_Code)) As Inventory_Invoice_code,                          
Bank_Title,Bank_Description,Bank_Amount,Bank_Date,                      
Case                      
When Payment_Details_Mode=1 Then Cash_Register_Payee_Name                                             
When Payment_Details_Mode=2 Then Cheque_Register_Payee_Name                                            
When Payment_Details_Mode=3 Then DD_Register_Payee_Name                           
When Payment_Details_Mode=6 Then Bank_Transfer_Payee_Name                                            
Else '''' End AS Payee_Name                    
--Case                      
--When Payment_Details_Mode=1 Then ''Cash''                                             
--When Payment_Details_Mode=2 Then ''Cheque''                                            
--When Payment_Details_Mode=3 Then ''DD''                           
--When Payment_Details_Mode=6 Then ''Bank Transfer''                                            
--Else '''' End AS Payment_Mode                                            
                     
  FROM  Tbl_Bank_Transfer CH                     
INNER JOIN Tbl_Payment_Details  p ON p.Payment_Details_Particulars_Id =CH.Bank_Id and  p.Payment_Details_Particulars=''Bank Transfer''                   
LEFT JOIN Tbl_Payment_Cash_Register cr  ON p.Payment_Details_Mode_Id= cr.Cash_Register_Id and Payment_Details_Mode=1                     
LEFT JOIN  Tbl_Payment_Cheque_Register chr ON p.Payment_Details_Mode_Id= chr.Cheque_Register_Id   and Payment_Details_Mode=2                    
LEFT JOIN  Tbl_Payment_DD_Register dr on p.Payment_Details_Mode_Id=dr.DD_Register_Id    and Payment_Details_Mode=3                    
LEFT JOIN  Tbl_Payment_Bank_Transfer bt on p.Payment_Details_Mode_Id=bt.Bank_Transfer_Id    and Payment_Details_Mode=6                    
                            
WHERE Bank_Status=0                              
Order by Bank_Date desc,Bank_Id desc                 
END
    ')
END;
