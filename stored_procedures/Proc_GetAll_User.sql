-- Check if the stored procedure [dbo].[Proc_GetAll_User] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAll_User]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_GetAll_User]
        AS
        BEGIN
            SELECT 
                tbl_User.[User_Id],
                tbl_User.role_Id,
                tbl_User.[user_name] AS [User],
                tbl_Role.role_Name AS [Role],
                tbl_User.user_Status AS [Status],
                tbl_User.user_password,
                tbl_User.user_Email AS [Mail]
            FROM tbl_User 
            INNER JOIN tbl_Role 
                ON tbl_User.role_Id = tbl_Role.role_Id 
            WHERE tbl_User.user_DeleteStatus = 0
        END
    ')
END
