IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Delete_Role_Privilage]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_Delete_Role_Privilage](@Privilege_Id int)

AS

BEGIN

    DELETE FROM [dbo].[Tbl_Role_Privilage]
        
        WHERE  Privilege_Id = @Privilege_Id

END
    ')
END
