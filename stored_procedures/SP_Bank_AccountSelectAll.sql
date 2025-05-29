IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Bank_AccountSelectAll]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[SP_Bank_AccountSelectAll]          
AS          
BEGIN          
SELECT   
BA.Account_Id,  
BA.Bank_Id,  
BR.Bank_Name,  
BR.Bank_Name+''-''+BR.Branch_Name As BankName,  
BR.Bank_Name+''-''+BR.Branch_Name+''-''+BA.Account_number as BankAccountNo,
BA.Account_number,  
BA.Account_Type  
  
  
  
   
FROM  Tbl_Bank_Account_Mapping  BA  
inner join Tbl_Bank_Registration  BR on BR.Bank_Id=BA.Bank_Id     
WHERE BA.Status=0          
END
    ')
END;
