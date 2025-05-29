IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_IncomeExpenseCategory_Delete]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[SP_Tbl_IncomeExpenseCategory_Delete]
 @Category_Id bigint
AS
BEGIN
UPDATE Tbl_Income_Expense_Category
   SET 
    Acc_Cat_DelStatus= 1
 WHERE Acc_Cat_Id=@Category_Id
END

   ')
END;
