IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Check_facultyname]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Check_facultyname]
            @facultyname VARCHAR(MAX)
        AS
        BEGIN
            SELECT * 
            FROM Tbl_Course_Level 
            WHERE Course_Level_Name = @facultyname 
                AND Delete_Status = 0
        END
    ')
END
