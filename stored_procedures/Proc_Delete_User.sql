IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Delete_User]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_Delete_User](@user_Id int)

AS

BEGIN

    UPDATE [dbo].[Tbl_User]
        SET     user_DeleteStatus     = 1
        WHERE  [user_Id] = @user_Id

END

    ')
END
