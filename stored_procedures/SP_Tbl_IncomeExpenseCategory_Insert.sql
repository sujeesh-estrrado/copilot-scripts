IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_IncomeExpenseCategory_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Tbl_IncomeExpenseCategory_Insert]          
 @Category_Name varchar(200),      
@Income_Expense bit          
AS     
  
IF exists (select * from Tbl_Income_Expense_Category where Acc_Cat_Name=@Category_Name and Acc_Cat_DelStatus=0 )  
begin  
RAISERROR (''Head Name Already Exists.'', -- Message text.          
               16, -- Severity.          
               1 -- State.          
               );    
end  
  
else  
       
BEGIN          
 INSERT INTO Tbl_Income_Expense_Category         
           (Acc_Cat_Name,Income_Expense)          
     VALUES          
           (@Category_Name,@Income_Expense)          
END    ')
END;
