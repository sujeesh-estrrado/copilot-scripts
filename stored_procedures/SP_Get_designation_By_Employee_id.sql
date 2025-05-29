IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_designation_By_Employee_id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_designation_By_Employee_id](@employee_id bigint)
AS
BEGIN
SELECT        RA.Emp_RoleAssignId, RA.employee_id, RA.role_id, RA.del_Status, RA.User_ID, R.role_Name, E.Employee_FName + '' '' + E.Employee_LName AS [Employee Name]
FROM            dbo.Tbl_RoleAssignment AS RA INNER JOIN
                         dbo.tbl_Role AS R ON RA.role_id = R.role_Id INNER JOIN
                         dbo.Tbl_Employee AS E ON E.Employee_Id = RA.employee_id where e.Employee_Id=@employee_id;
END

	');
END;
