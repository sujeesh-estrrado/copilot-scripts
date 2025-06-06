-- Check if the stored procedure [dbo].[Proc_Insert_User] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert_User]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Insert_User]
        (
            @user_id BIGINT,
            @role_Id INT,
            @user_name VARCHAR(100),
            @user_password VARCHAR(50),
            @user_Status BIT,
            @user_DeleteStatus BIT,
            @user_Email VARCHAR(50)
        )
        AS
        BEGIN
            -- Insert a new user record into the Tbl_User table
            INSERT INTO Tbl_User ([user_Id], role_Id, [user_name], user_password, user_Status, user_DeleteStatus, user_Email)
            VALUES (@user_id, @role_Id, @user_name, @user_password, @user_Status, @user_DeleteStatus, @user_Email);
            
            -- Return the identity (the last inserted user ID) of the inserted record
            SELECT SCOPE_IDENTITY();
        END
    ')
END
