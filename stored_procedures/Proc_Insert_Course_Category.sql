-- Check if the stored procedure [dbo].[Proc_Insert_Course_Category] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert_Course_Category]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Insert_Course_Category]
        (
            @course_category_name VARCHAR(300),
            @course_category_Descripition VARCHAR(500),
            @course_category_date DATETIME
        )
        AS
        BEGIN
            -- Insert a new course category into Tbl_Course_Category
            INSERT INTO Tbl_Course_Category 
            (
                Course_category_name, 
                Course_category_Descripition, 
                Course_category_date
            )
            VALUES 
            (
                @course_category_name, 
                @course_category_Descripition, 
                @course_category_date
            )

            -- Return the newly inserted identity (ID) value
            SELECT SCOPE_IDENTITY()
        END
    ')
END
