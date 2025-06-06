IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Update_RoleHierarchy]') 
    AND type = N'P'
)
BEGIN
    EXEC('
              
CREATE procedure [dbo].[Proc_Update_RoleHierarchy]      
(@role_hierarchy_Id bigint,@role_Id int,@reporting_role_Id int)        
          
AS          
          
BEGIN        
      
begin tran      
--  IF NOT EXISTS (SELECT * FROM Tbl_Role_hierarchy WHERE role_Id=@role_Id)         
   UPDATE Tbl_Role_hierarchy      
   SET      
      role_Id=@role_Id,      
      reporting_role_Id=@reporting_role_Id      
 WHERE role_hierarchy_Id=@role_hierarchy_Id and role_hierarchy_DelStatus=0      
        
commit tran        
             
END
    ')
END
