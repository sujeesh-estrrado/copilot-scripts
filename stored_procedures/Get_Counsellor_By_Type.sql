IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_Counsellor_By_Type]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE Procedure [dbo].[Get_Counsellor_By_Type]

@Counsellor_Type varchar(20)

as
begin 

select  distinct  E.Employee_Id as Employee_Id,concat(E.Employee_FName,'' '',E.Employee_LName) as EmployeeName,E.Employee_Id

from Tbl_Employee E   
inner join Tbl_RoleAssignment RA on RA.employee_id=E.Employee_Id 
 inner join tbl_Role R on R.role_Id=RA.role_id 

   WHERE    
   (R.role_Name = ''Counsellor'' )  and     
  E.Employee_Status=0   
    and    ( Counselor_Type = ''Local-International'' or Counselor_Type = @Counsellor_Type)
 order by E.Employee_Id

 end
    ')
END;