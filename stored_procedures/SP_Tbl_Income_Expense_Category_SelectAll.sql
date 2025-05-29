IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Income_Expense_Category_SelectAll]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Tbl_Income_Expense_Category_SelectAll]      
AS      
BEGIN      
SELECT   Acc_Cat_Id,Acc_Cat_Name,    
CASE Income_Expense    
  WHEN ''True'' THEN ''Expense''     
  ELSE ''Income''     
END as Income_Expense    
  FROM  dbo.Tbl_Income_Expense_Category    
WHERE Acc_Cat_DelStatus=0  
Order by  Acc_Cat_Id Desc   
END

   ')
END;
