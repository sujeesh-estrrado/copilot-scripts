IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Getall_faqcultydean]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Getall_faqcultydean]
as
begin
SELECT        dbo.tbl_Role.role_Name,concat(dbo.Tbl_Employee.Employee_FName,'' '',dbo.Tbl_Employee.Employee_LName) as Employee_Name, dbo.Tbl_Employee_User.Employee_Id, dbo.Tbl_Employee_User.User_Id
FROM            dbo.Tbl_Employee INNER JOIN
                         dbo.Tbl_Employee_User ON dbo.Tbl_Employee.Employee_Id = dbo.Tbl_Employee_User.Employee_Id INNER JOIN
                         dbo.Tbl_RoleAssignment ON dbo.Tbl_Employee.Employee_Id = dbo.Tbl_RoleAssignment.employee_id AND dbo.Tbl_Employee_User.User_Id = dbo.Tbl_RoleAssignment.User_ID INNER JOIN
                         dbo.tbl_Role ON dbo.Tbl_RoleAssignment.role_id = dbo.tbl_Role.role_Id where  dbo.tbl_Role.role_Name=''FacultyDean'' ;
						 end  
');
END;