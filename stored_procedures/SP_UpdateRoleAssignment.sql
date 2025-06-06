IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_UpdateRoleAssignment]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure [dbo].[SP_UpdateRoleAssignment]      
  (@employee_id bigint      
           ,@role_id int      
           ,@Roelassign_id bigint,    
@userid bigint)      
AS BEGIN      
    if exists(select role_id from tbl_role where role_id=@role_id)  
    begin  
UPDATE  [Tbl_RoleAssignment]      
SET      
           [employee_id]=@employee_id      
           ,[role_id]=@role_id ,     
           [User_ID]=@userid    
WHERE Emp_RoleAssignId=@Roelassign_id      
     end   
     else  
     select 0  
      
END    
    ')
END;
