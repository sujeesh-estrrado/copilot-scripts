IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_Counsellor_Employees]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[sp_Get_Counsellor_Employees]  
  (  
  @flag bigint=0  
  )  
as  
BEGIN  
if(@flag=0)  
begin  
   select distinct E.Employee_Id as Employee_Id,Concat(Employee_FName,'' '',Employee_LName)  
    as Employee_Name,E.Employee_Mail from Tbl_Employee E   
 inner join Tbl_Employee_User EU on EU.Employee_Id=E.Employee_Id  
 inner join Tbl_User U on U.user_Id=EU.User_Id  
 inner join Tbl_RoleAssignment RA on RA.employee_id=E.Employee_Id  
 left join Tbl_Employee_Official eo on eo.Employee_Id=E.Employee_Id  
 left join Tbl_Emp_Department ed on ed.Dept_Id=eo.Department_Id and  ed.Dept_Id=10  
 inner join tbl_Role R on R.role_Id=RA.role_id  
  WHERE  
   (R.role_Name = ''Counsellor'' or R.role_Name=''Counsellor Lead''  or R.role_Name=''Marketing Manager''  or R.role_Name=''PSO'')  and   
   Employee_Status=0  
 order by Concat(Employee_FName,'' '',Employee_LName)  
 end  
 if(@flag=1)  
begin  
   select count(E.Employee_Id) as counts from Tbl_Employee E   
 inner join Tbl_Employee_User EU on EU.Employee_Id=E.Employee_Id  
 inner join Tbl_User U on U.user_Id=EU.User_Id  
 inner join Tbl_RoleAssignment RA on RA.employee_id=E.Employee_Id  
 left join Tbl_Employee_Official eo on eo.Employee_Id=E.Employee_Id  
 left join Tbl_Emp_Department ed on ed.Dept_Id=eo.Department_Id and  ed.Dept_Id=10  
 inner join tbl_Role R on R.role_Id=RA.role_id  
  WHERE  
   (R.role_Name = ''Counsellor'' or R.role_Name=''Counsellor Lead''  or R.role_Name=''Marketing Manager''  or R.role_Name=''PSO'')  and   
   Employee_Status=0  
  
 end  
  
END
    ');
END;
