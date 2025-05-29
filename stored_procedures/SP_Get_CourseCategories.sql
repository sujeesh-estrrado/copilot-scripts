IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_CourseCategories]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Get_CourseCategories]
AS
BEGIN
    SELECT 
        Course_Category_Id AS ID, 
        Course_Category_Name 
    FROM 
        Tbl_Course_Category
    ORDER BY 
        Course_Category_Name; -- Optional: Order by name for better UX
END;  

    ');
END;
