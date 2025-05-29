IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_getAll_facultymapping]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_getAll_facultymapping]
as
begin 
SELECT        dbo.tbl_Role.role_Name,concat(dbo.Tbl_Employee.Employee_FName,'' '', dbo.Tbl_Employee.Employee_LName)as Employee_name, dbo.Tbl_Employee_User.Employee_Id, dbo.Tbl_Employee_User.User_Id, dbo.Tbl_Course_Level.Faculty_dean_id, 
                         dbo.Tbl_Course_Level.Course_Level_Name,dbo.Tbl_Course_Level.Course_Level_id
FROM            dbo.Tbl_Employee INNER JOIN
                         dbo.Tbl_Employee_User ON dbo.Tbl_Employee.Employee_Id = dbo.Tbl_Employee_User.Employee_Id INNER JOIN
                         dbo.Tbl_RoleAssignment ON dbo.Tbl_Employee.Employee_Id = dbo.Tbl_RoleAssignment.employee_id AND dbo.Tbl_Employee_User.User_Id = dbo.Tbl_RoleAssignment.User_ID INNER JOIN
                         dbo.tbl_Role ON dbo.Tbl_RoleAssignment.role_id = dbo.tbl_Role.role_Id INNER JOIN
                         dbo.Tbl_Course_Level ON dbo.Tbl_Employee_User.Employee_Id = dbo.Tbl_Course_Level.Faculty_dean_id
						 end  
');
END;