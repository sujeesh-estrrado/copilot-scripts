IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Delete_RoleHierarchy]') 
    AND type = N'P'
)
BEGIN
    EXEC('
          
CREATE procedure [dbo].[Proc_Delete_RoleHierarchy]  
(@role_hierarchy_Id bigint)    
      
AS      
      
BEGIN    
  
begin tran    
   UPDATE Tbl_Role_hierarchy  
   SET  
      role_hierarchy_DelStatus=1  
  
 WHERE role_hierarchy_Id=@role_hierarchy_Id   
    
commit tran    
         
END
    ')
END
