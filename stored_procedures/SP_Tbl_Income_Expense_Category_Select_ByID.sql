IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Income_Expense_Category_Select_ByID]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[SP_Tbl_Income_Expense_Category_Select_ByID] 
 @Category_Id bigint
AS
BEGIN
SELECT Acc_Cat_Id,Acc_Cat_Name
  FROM dbo.Tbl_Income_Expense_Category
WHERE Acc_Cat_Id=@Category_Id
END

   ')
END;
