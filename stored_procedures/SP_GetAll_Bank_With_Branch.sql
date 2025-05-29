IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Bank_With_Branch]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_Bank_With_Branch]            
    
         
AS     
Begin    
select   
Bank_Id,    
Bank_Name+''-''+Branch_Name as BankName    
from Tbl_bank_Registration 
where Status=0   
    
END

    ')
END;
