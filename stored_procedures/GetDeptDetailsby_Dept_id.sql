IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[GetDeptDetailsby_Dept_id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[GetDeptDetailsby_Dept_id] (@Dept_id bigint)
As
Begin
SELECT     Tbl_Emp_Department.Dept_Id,Tbl_Emp_Department.Dept_Name
FROM         Tbl_Emp_Department
where Dept_Id=@Dept_Id
End
    ')
END
