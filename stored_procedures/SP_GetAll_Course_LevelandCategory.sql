IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Course_LevelandCategory]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_Course_LevelandCategory] 
AS    
    
BEGIN 

SELECT     *
FROM         Tbl_Course_Level INNER JOIN
                      Tbl_Course_Category ON Tbl_Course_Level.Course_Level_Id = Tbl_Course_Category.Course_level_Id
where Tbl_Course_Category.Course_Category_Status = 0 and Tbl_Course_Level.Course_Level_Status=0
END
');
END;