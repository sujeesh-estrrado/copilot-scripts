IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Department]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_Department]  
as        
begin        
select Tbl_Course_Department.Course_Category_Id as CategoryId,        
  Tbl_Course_Department.Course_Department_Id as CourseDepartmentID,        
    Tbl_Course_Department.Department_Id as DepartmentID,        
       Tbl_Department.Department_Name as DepartmentName        
from Tbl_Course_Department        
inner join Tbl_Department on Tbl_Course_Department.Department_Id=Tbl_Department.Department_Id        
        
where Tbl_Course_Department.Course_Department_Status=0 and Tbl_Department.Department_Status=0  
        
order by DepartmentName    
end 

');
END;