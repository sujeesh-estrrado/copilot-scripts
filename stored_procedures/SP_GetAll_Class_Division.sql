IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Class_Division]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_Class_Division]    
    
AS    
    
BEGIN    
 SELECT *                    
FROM                        
   (SELECT     
ROW_NUMBER() OVER (PARTITION BY dbo.Tbl_Course_Department.Course_Department_Id ORDER BY dbo.Tbl_Course_Department.Course_Department_Id) as num,
 Duration_Mapping_Id, dbo.Tbl_Course_Category.Course_Category_Name, dbo.Tbl_Course_Department.Course_Department_Id, dbo.Tbl_Course_Department.Department_Id,     
                      dbo.Tbl_Course_Department.Course_Category_Id, dbo.Tbl_Course_Department.Course_Department_Description,     
                      dbo.Tbl_Course_Department.Course_Department_Date, dbo.Tbl_Department.Department_Name    
FROM         dbo.Tbl_Department INNER JOIN    
                      dbo.Tbl_Course_Department ON dbo.Tbl_Department.Department_Id = dbo.Tbl_Course_Department.Department_Id INNER JOIN    
                      dbo.Tbl_Course_Category ON dbo.Tbl_Course_Department.Course_Category_Id = dbo.Tbl_Course_Category.Course_Category_Id    
    INNER JOIN Tbl_Course_Duration_Mapping ON dbo.Tbl_Course_Department.Course_Department_Id = Tbl_Course_Duration_Mapping.Course_Department_Id
    
       where Tbl_Course_Department.Course_Department_Status=0 and    
                 Tbl_Course_Category.Course_Category_Status=0 and    
                 Tbl_Department.Department_Status=0 )tbl                      
where tbl.num=1            
order by Course_Department_Id
       
END
	');
END;
