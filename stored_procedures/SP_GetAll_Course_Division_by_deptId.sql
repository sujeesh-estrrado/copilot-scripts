IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Course_Division_by_deptId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_Course_Division_by_deptId]     
(@course_department_id bigint)      
        
AS        
        
BEGIN       
      
SELECT           
dbo.Tbl_Course_Category.Course_Category_Name,      
dbo.Tbl_Course_Department.Course_Department_Id,       
dbo.Tbl_Course_Department.Department_Id,         
dbo.Tbl_Course_Department.Course_Category_Id,       
dbo.Tbl_Course_Department.Course_Department_Description,         
dbo.Tbl_Course_Department.Course_Department_Date,      
dbo.Tbl_Department.Department_Name        
FROM  dbo.Tbl_Department   
INNER JOIN  dbo.Tbl_Course_Department ON dbo.Tbl_Department.Department_Id = dbo.Tbl_Course_Department.Department_Id --dbo.Tbl_Course_Department.Department_Id   
INNER JOIN dbo.Tbl_Course_Category ON dbo.Tbl_Course_Department.Course_Category_Id = dbo.Tbl_Course_Category.Course_Category_Id            
where Tbl_Course_Department.Course_Department_Status=0 and   Tbl_Course_Category.Course_Category_Status=0   
and Tbl_Department.Department_Status=0 and   
Tbl_Course_Department.department_id=       
(Select department_id From Tbl_Course_Department      
 Where Tbl_Course_Department.department_id=@course_department_id)-- @course_department_id)      
--and Tbl_Course_Department.department_id<>24--@course_department_id      
END    
');
END;