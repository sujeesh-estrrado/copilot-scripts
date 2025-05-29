IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetRoleBy_EmployeeId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_GetRoleBy_EmployeeId]  
@Employee_Id bigint  
AS  
BEGIN  
   
 SELECT r.role_Name from Tbl_Employee_User eu   
 inner join dbo.Tbl_Employee e on eu.Employee_Id=e.Employee_Id     
 inner join dbo.Tbl_User u on u.user_Id=eu.User_Id    
 inner join tbl_Role r on r.role_Id=u.role_Id where e.Employee_Id=@Employee_Id   
   
END
');
END;