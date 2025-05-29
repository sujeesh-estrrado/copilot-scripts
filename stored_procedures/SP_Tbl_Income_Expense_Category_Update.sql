IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Income_Expense_Category_Update]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[SP_Tbl_Income_Expense_Category_Update]        
 @Category_Id bigint,        
 @Category_Name varchar(200) ,    
@Income_Expense bit       
AS    
if exists   
(select Acc_Cat_Name from Tbl_Income_Expense_Category where Acc_Cat_Name= @Category_Name and Acc_Cat_Id<>@Category_Id )  
BEGIN                
RAISERROR (''Data Already Exists.'', -- Message text.                
               16, -- Severity.                
               1 -- State.                
               );                
END                
ELSE     
BEGIN         
        
UPDATE dbo.Tbl_Income_Expense_Category       
   SET  Acc_Cat_Name= @Category_Name,     
        Income_Expense=@Income_Expense    
 WHERE Acc_Cat_Id=@Category_Id        
END

   ')
END;
