IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_CourseCategory_By_Course_Level]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_CourseCategory_By_Course_Level]  --2     
(@Course_level_Id bigint=0 )       
as        
begin        
--select Course_Category_Id as CategoryID,Course_level_Id as LevelID,Course_Category_Name as CategoryName        
--from Tbl_Course_Category where Course_Category_Id=@Course_level_Id and Course_Category_Status=0       
--order by  CategoryName      
  
select distinct c.Course_Category_Id as CategoryID,cc.Course_Category_Name as CategoryName,D.GraduationTypeId as LevelID from  
  Tbl_Course_Department  c  
  inner join Tbl_Course_Category cc on cc.Course_Category_Id=c.Course_Category_Id  
  inner join Tbl_Department d on d.Department_Id=c.Department_Id where d.GraduationTypeId=@Course_level_Id    
        
end    

    ');
END;
