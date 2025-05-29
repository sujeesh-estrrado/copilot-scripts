IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetRoleAssignment_ByID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetRoleAssignment_ByID]  
  (  
   @Roelassign_id bigint)  
AS BEGIN  
  
  
Select A.*,E.Counselor_Type from  [Tbl_RoleAssignment] A 
left join Tbl_Employee E on E.Employee_Id=A.employee_id
           
WHERE Emp_RoleAssignId=@Roelassign_id and  del_Status=0
   
  
END
');
END;