-- Check if the stored procedure [dbo].[Proc_Insert_User_inOrganisation] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert_User_inOrganisation]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Insert_User_inOrganisation]
        (
            @role_Id INT,
            @user_Id INT
        )
        AS
        BEGIN
            -- Insert a new user-role record into the Tbl_User table
            INSERT INTO Tbl_User (role_Id, user_Id)
            VALUES (@role_Id, @user_Id);
        END
    ')
END
