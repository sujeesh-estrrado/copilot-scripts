-- Check if the stored procedure [dbo].[Proc_Insert_Agent_User] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert_Agent_User]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Insert_Agent_User] 
        (
            @Agent_Id BIGINT, 
            @User_Id BIGINT
        )
        AS
        BEGIN
            -- Insert values into the Tbl_Agent_User table
            INSERT INTO dbo.Tbl_Agent_User (Agent_Id, User_Id)
            VALUES (@Agent_Id, @User_Id)
            
            -- Return the inserted identity value
            SELECT SCOPE_IDENTITY()
        END
    ')
END
