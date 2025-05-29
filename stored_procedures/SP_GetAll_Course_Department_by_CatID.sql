IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Course_Department_by_CatID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_Course_Department_by_CatID]-- 2
(@Course_Category_Id bigint=0,
@GraduationTypeId bigint=0)    
as    
begin    
--select Tbl_Course_Department.Course_Category_Id as CategoryId,    
--  Tbl_Course_Department.Course_Department_Id as CourseDepartmentID,    
--    Tbl_Course_Department.Department_Id as DepartmentID,    
--       Tbl_Department.Department_Name as DepartmentName    
--from Tbl_Course_Department    
--inner join Tbl_Department on Tbl_Course_Department.Department_Id=Tbl_Department.Department_Id    
  
--where Tbl_Course_Department.Course_Department_Status=0 and Tbl_Department.Department_Status=0 
--and Tbl_Course_Department.Course_Category_Id=@Course_Category_Id    
--order by DepartmentName

select Tbl_Course_Department.Course_Category_Id as CategoryId,    
  Tbl_Course_Department.Course_Department_Id as CourseDepartmentID,    
    Tbl_Course_Department.Department_Id as DepartmentID,    
       Tbl_Department.Department_Name as DepartmentName    
from Tbl_Course_Department    
inner join Tbl_Department on Tbl_Course_Department.Department_Id=Tbl_Department.Department_Id    
inner join dbo.Tbl_Course_Level ON dbo.Tbl_Department.GraduationTypeId = dbo.Tbl_Course_Level.Course_Level_Id    
where Tbl_Course_Department.Course_Department_Status=0 and Tbl_Department.Department_Status=0 
and Tbl_Course_Department.Course_Category_Id=@Course_Category_Id  and GraduationTypeId=@GraduationTypeId and  Tbl_Department.Active_Status=''Active''
order by DepartmentName
end


');
END;