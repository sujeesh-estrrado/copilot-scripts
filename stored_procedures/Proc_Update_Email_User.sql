IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Update_Email_User]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_Update_Email_User](@user_Id int,@user_password varchar(50))

AS

BEGIN

    UPDATE [dbo].[Tbl_User]
        SET    
               user_password             = @user_password
                
        WHERE  [user_Id] = @user_Id

END
    ')
END
