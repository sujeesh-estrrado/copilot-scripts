IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[GetDeptDetailsby_Emp_id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[GetDeptDetailsby_Emp_id](@emp_id bigint)
As
Begin
select e.Employee_Id,e.Department_Id,d.Dept_Name
from dbo.Tbl_Employee_Official e
left join dbo.Tbl_Emp_Department d on  e.Department_Id =d.Dept_Id
where e.Employee_Id=@emp_id;
End

    ')
END
