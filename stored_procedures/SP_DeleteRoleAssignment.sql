IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_DeleteRoleAssignment]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_DeleteRoleAssignment]    
  (    
   @Roelassign_id bigint)    
AS BEGIN    
    
    
DELETE FROM  [Tbl_RoleAssignment]           
WHERE employee_id=@Roelassign_id    
     
    
END 
    ')
END
