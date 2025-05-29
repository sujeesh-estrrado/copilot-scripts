IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_role_by_EmployeeId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE  procedure [dbo].[Sp_Get_role_by_EmployeeId]
(@Employee_Id bigint)
as
begin
SELECT        U.role_Id, EU.User_Id,R.role_Name
FROM            dbo.Tbl_Employee_User EU left JOIN
                         dbo.Tbl_User U ON EU.User_Id = U.user_Id 
						 left join tbl_Role R on R.role_Id=U.role_Id where EU.Employee_Id=@Employee_Id;
						 end');
END;
