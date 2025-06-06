IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_User_GetByLoginCredentials]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[SP_User_GetByLoginCredentials]
    (@userName VARCHAR(50),
    @userPass VARCHAR(50))
AS
BEGIN
    SELECT A.user_Id, A.role_Id, A.user_name, A.user_password, A.user_Status, A.user_Email, 
    B.role_Name FROM dbo.Tbl_User A 
    LEFT JOIN dbo.tbl_Role B ON A.role_Id = B.role_Id
    WHERE A.user_name = @userName AND A.user_password = @userPass
END
    ')
END
