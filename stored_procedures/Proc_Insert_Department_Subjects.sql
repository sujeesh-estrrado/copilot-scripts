-- Check if the stored procedure [dbo].[Proc_Insert_Department_Subjects] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert_Department_Subjects]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Insert_Department_Subjects]
        (
            @Course_Department_Id BIGINT,
            @Subject_Id BIGINT
        )
        AS
        BEGIN
            -- Check if the record already exists in Tbl_Department_Subjects
            IF NOT EXISTS(
                SELECT * 
                FROM Tbl_Department_Subjects 
                WHERE Course_Department_Id = @Course_Department_Id
                AND Subject_Id = @Subject_Id
            )
            BEGIN
                -- Insert into Tbl_Department_Subjects
                INSERT INTO Tbl_Department_Subjects
                (
                    Course_Department_Id, 
                    Subject_Id
                )
                VALUES
                (
                    @Course_Department_Id,
                    @Subject_Id
                )

                -- Return the inserted identity
                SELECT @@IDENTITY
            END
        END
    ')
END
