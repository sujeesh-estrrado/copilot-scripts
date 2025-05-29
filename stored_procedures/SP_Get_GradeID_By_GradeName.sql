IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_GradeID_By_GradeName]')
    AND type = N'P'
)
BEGIN
    EXEC('
  create procedure [dbo].[SP_Get_GradeID_By_GradeName]
(@Emp_Grade_Name varchar(50))
AS
BEGIN

SELECT*FROM dbo.Tbl_Employee_Grade WHERE Emp_Grade_Name=@Emp_Grade_Name
END

    ')
END
