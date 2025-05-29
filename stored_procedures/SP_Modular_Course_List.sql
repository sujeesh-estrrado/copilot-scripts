IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Modular_Course_List]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE PROCEDURE [dbo].[SP_Modular_Course_List]         
(        
    @Flag INT = 0,        
    @SearchTerm VARCHAR(MAX) = '''',        
    @CurrentPage BIGINT = 0,        
    @PageSize BIGINT = 0
)        
AS        
BEGIN        
    
    DECLARE @TotalRecords INT;
    SELECT 
        @TotalRecords = COUNT(DISTINCT ID)
    FROM 
        tbl_Modular_Courses
    WHERE 
        Isdeleted = 0
        AND (
    @SearchTerm IS NULL 
    OR LTRIM(RTRIM(@SearchTerm)) = '''' 
    OR CourseName LIKE ''%'' + @SearchTerm + ''%'' 
    OR CourseCode LIKE ''%'' + @SearchTerm + ''%''
);

    WITH RankedCourses AS (
        SELECT 
            ID,
            CourseName,
            CourseCode,
            ROW_NUMBER() OVER (ORDER BY ID DESC) AS RowNum
        FROM 
            tbl_Modular_Courses
        WHERE 
            Isdeleted = 0
            AND (
    @SearchTerm IS NULL 
    OR LTRIM(RTRIM(@SearchTerm)) = '''' 
    OR CourseName LIKE ''%'' + @SearchTerm + ''%'' 
    OR CourseCode LIKE ''%'' + @SearchTerm + ''%''
)

    )
    SELECT 
        ID,
        CourseName,
        CourseCode,
        RowNum,
        @TotalRecords AS TotalRecords
    FROM 
        RankedCourses 
END
    ')
END;
