IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_User_Exist_With_RoleId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_User_Exist_With_RoleId](@role_Id int)


AS
Set NoCount ON

BEGIN

    select role_Id from Tbl_User where role_Id=@role_Id

END
    ')
END
