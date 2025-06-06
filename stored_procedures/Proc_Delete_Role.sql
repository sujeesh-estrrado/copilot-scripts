IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Delete_Role]') 
    AND type = N'P'
)
BEGIN
    EXEC('
         CREATE procedure [dbo].[Proc_Delete_Role]   
 (@role_Id int)          
          
AS                  
BEGIN          
--delete from [tbl_Role]          
--WHERE  role_Id = @role_Id    
if exists(select role_Name from tbl_Role where [static] = 1 and role_Id = @role_Id)
        begin
            RAISERROR (''CannotDeleteStaticRole'', -- Message text.
            16, -- Severity.
            1 -- State.
            );
        end
        else
        begin
        
    if not exists (select * from Tbl_RoleAssignment where role_id=@role_Id and del_status=0)
    begin    
            UPDATE [dbo].[tbl_Role]          
            SET    role_DeleteStatus=1          
            WHERE  role_Id = @role_Id  
            --if exists(select role_Id from Tbl_RoleAssignment where role_Id=@role_Id)          
            delete from Tbl_RoleAssignment       
            where  role_Id = @role_Id  
        end    
   end 
END   



--select * from Tbl_RoleAssignment
    ')
END
