-- Check if the stored procedure [dbo].[Proc_Insert_Course_Level] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert_Course_Level]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Insert_Course_Level]
        (
            @course_level_name VARCHAR(300),
            @course_level_Descripition VARCHAR(500),
            @course_level_date DATETIME
        )
        AS
        BEGIN
            -- Insert a new course level into Tbl_Course_Level
            INSERT INTO Tbl_Course_Level 
            (
                Course_level_name, 
                Course_level_Descripition, 
                Course_level_date
            )
            VALUES 
            (
                @course_level_name, 
                @course_level_Descripition, 
                @course_level_date
            )

            -- Return the newly inserted identity (ID) value
            SELECT SCOPE_IDENTITY()
        END
    ')
END
