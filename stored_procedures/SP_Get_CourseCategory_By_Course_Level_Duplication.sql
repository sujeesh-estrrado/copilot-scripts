IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_CourseCategory_By_Course_Level_Duplication]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_CourseCategory_By_Course_Level_Duplication]   
(@Course_level_Id bigint,
@CategoryId bigint)    
as    
begin    
select Course_Category_Id as CategoryID,Course_level_Id as LevelID,Course_Category_Name as CategoryName    
from Tbl_Course_Category where Course_level_Id=@Course_level_Id and Course_Category_Id= @CategoryId
order by  CategoryName  
    
end
    ');
END;
