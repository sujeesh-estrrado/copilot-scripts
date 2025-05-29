IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Employees_Cashier]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Employees_Cashier] 

AS  
BEGIN
select distinct E.Employee_Id,CONCAT(Employee_FName,'' '',Employee_LName) as EmployeeName,RA.* from Tbl_Employee E
left join Tbl_Employee_User EU on E.Employee_Id=EU.Employee_Id
left join Tbl_User U on U.user_Id=EU.User_Id
left join Tbl_RoleAssignment RA on RA.User_ID=U.user_Id 
left join tbl_Role R on R.role_Id=RA.role_id
where (role_Name=''Cashier'' or role_Name=''Credit Control Staff'') and Employee_Status=0 order by CONCAT(Employee_FName,'' '',Employee_LName)
END
	');
END;
