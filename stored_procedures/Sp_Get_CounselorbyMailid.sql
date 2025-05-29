IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_CounselorbyMailid]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Get_CounselorbyMailid](@Mailid varchar(max))  
as  
begin  
  
select E.Employee_Id,E.Employee_FName,E.Employee_Mail from Tbl_Employee E inner join Tbl_RoleAssignment R on E.Employee_Id=R.employee_id  
left join tbl_Role ro on ro.role_Id=R.role_id   
where E.Employee_Status=0 and ( ro.role_Name=''Counsellor'' or ro.role_Name=''Counsellor Lead'' or ro.role_Name=''Marketing Manager'' or ro.role_Name=''PSO'') and  E.Employee_Mail=@Mailid   
  
  
end  
  
    ');
END;
