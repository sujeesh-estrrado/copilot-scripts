-- Check if the stored procedure [dbo].[Proc_Insert_Temp_Password] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert_Temp_Password]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Insert_Temp_Password]
        (
            @user_Id INT
        )
        AS
        BEGIN
            -- Insert a record into TblTemp_Password with the provided user ID
            INSERT INTO TblTemp_Password (User_Id)
            VALUES (@user_Id);
        END
    ')
END
