IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_Counsellor_Employees_ByType]') 
    AND type = N'P'
)
BEGIN
    EXEC('
   
CREATE procedure [dbo].[sp_Get_Counsellor_Employees_ByType] --''Local''
(
@Employee_Type  varchar(Max)= '''',
@flag bigint=0
)
as
BEGIN
if(@flag=0)
begin
    SELECT DISTINCT dbo.Tbl_RoleAssignment.employee_id AS Employee_Id, Concat(Employee_FName,'' '',Employee_LName) as Employee_Name
    FROM            dbo.Tbl_User INNER JOIN
                             dbo.tbl_Role ON dbo.Tbl_User.role_Id = dbo.tbl_Role.role_Id INNER JOIN
                             dbo.Tbl_RoleAssignment ON dbo.tbl_Role.role_Id = dbo.Tbl_RoleAssignment.role_id INNER JOIN
                             dbo.Tbl_Employee ON dbo.Tbl_RoleAssignment.employee_id = dbo.Tbl_Employee.Employee_Id
    WHERE        (dbo.tbl_Role.role_Name = ''Counsellor'') and (Counselor_Type=@Employee_Type or Counselor_Type=''Local-International'')  order by Employee_Name asc
end
if(@flag=1)
begin
    SELECT DISTINCT dbo.Tbl_RoleAssignment.employee_id AS Employee_Id, Concat(Employee_FName,'' '',Employee_LName) as Employee_Name
    FROM            dbo.Tbl_User INNER JOIN
                             dbo.tbl_Role ON dbo.Tbl_User.role_Id = dbo.tbl_Role.role_Id INNER JOIN
                             dbo.Tbl_RoleAssignment ON dbo.tbl_Role.role_Id = dbo.Tbl_RoleAssignment.role_id INNER JOIN
                             dbo.Tbl_Employee ON dbo.Tbl_RoleAssignment.employee_id = dbo.Tbl_Employee.Employee_Id
    WHERE        (dbo.tbl_Role.role_Name = ''Counsellor'') and
    (Counselor_Type=@Employee_Type or Counselor_Type=''Local-International'') and
    Employee_Status=0 and (Counselor_Type is not null and Counselor_Type!='' '')
     order by Employee_Name asc
end
END
    ');
END;
