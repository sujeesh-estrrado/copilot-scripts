IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Update_Role_Privilage]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       
CREATE procedure [dbo].[Proc_Update_Role_Privilage](@role_Id int)
                    

AS

BEGIN

    /*UPDATE [dbo].[Tbl_Role_Privilage]
        SET    role_Id               = @role_Id ,
               Menu_Id               = @Menu_Id
        WHERE  Privilege_Id = @Privilege_Id*/

delete from [Tbl_Role_Privilage] where role_Id   = @role_Id ;


END
    ')
END
