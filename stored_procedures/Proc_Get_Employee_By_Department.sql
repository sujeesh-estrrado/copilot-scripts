IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_Employee_By_Department]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_Get_Employee_By_Department](@Dept_Id bigint)

AS

BEGIN


SELECT     Tbl_Employee_Official.Employee_Id,Tbl_Employee.Employee_FName +'' ''+Tbl_Employee.Employee_LName as Employee , Tbl_Emp_Department.Dept_Name
FROM         Tbl_Employee_Official INNER JOIN
                      Tbl_Employee ON Tbl_Employee_Official.Employee_Id = Tbl_Employee.Employee_Id INNER JOIN
                      Tbl_Emp_Department ON Tbl_Employee_Official.Department_Id = Tbl_Emp_Department.Dept_Id
where Tbl_Emp_Department.Dept_Id =@Dept_Id and Tbl_Employee.Employee_Status=0

END
    ')
END
