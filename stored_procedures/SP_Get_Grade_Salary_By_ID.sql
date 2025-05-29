IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Grade_Salary_By_ID]')
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Grade_Salary_By_ID](@Grade_Sal_Id bigint)

AS
Set NoCount ON
BEGIN

    SELECT     dbo.Tbl_Grade_Salary.Grade_Sal_Id, dbo.Tbl_Grade_Salary.Salary_Head_ID, dbo.Tbl_Grade_Salary.Grade_Id, dbo.Tbl_Grade_Salary.Grade_Sal_Value, 
                      dbo.Tbl_Grade_Salary.Mode_Calculation, dbo.Tbl_Employee_Grade.Emp_Grade_Name, dbo.Tbl_Salary_Head.Salary_Head_Name
FROM         dbo.Tbl_Grade_Salary INNER JOIN
                      dbo.Tbl_Employee_Grade ON dbo.Tbl_Grade_Salary.Grade_Id = dbo.Tbl_Employee_Grade.Emp_Grade_Id INNER JOIN
                      dbo.Tbl_Salary_Head ON dbo.Tbl_Grade_Salary.Salary_Head_ID = dbo.Tbl_Salary_Head.Salary_Head_Id
WHERE     (dbo.Tbl_Grade_Salary.GradeSal_Delete_Status = 0) AND (dbo.Tbl_Employee_Grade.Emp_Grade_Status = 0) AND 
                      (dbo.Tbl_Salary_Head.Salary_head_Delete_Status = 0)
            AND  Grade_Sal_Id  = @Grade_Sal_Id

END



    ')
END
