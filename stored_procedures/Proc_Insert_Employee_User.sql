-- Check if the stored procedure [dbo].[Proc_Insert_Employee_User] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert_Employee_User]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Insert_Employee_User]
        (
            @Employee_Id BIGINT,
            @User_Id INT,
            @Lmsaccess VARCHAR(255)
        )
        AS
        BEGIN
            -- Insert the new employee user into the Tbl_Employee_User table
            INSERT INTO dbo.Tbl_Employee_User (Employee_Id, User_Id, LMS_access)
            VALUES (@Employee_Id, @User_Id, @Lmsaccess);

            -- Return the identity of the inserted record
            SELECT SCOPE_IDENTITY();
        END
    ')
END
