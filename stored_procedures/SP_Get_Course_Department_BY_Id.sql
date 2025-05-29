IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Course_Department_BY_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Course_Department_BY_Id]
(@Course_Department_Id bigint)    
    
AS    
    
BEGIN    
    
SELECT     Tbl_Department.Course_Code,dbo.Tbl_Course_Category.Course_Category_Name, dbo.Tbl_Course_Department.Course_Department_Id, 
dbo.Tbl_Course_Department.Department_Id,     
dbo.Tbl_Course_Department.Course_Category_Id,
dbo.Tbl_Course_Department.Course_Department_Description,     
dbo.Tbl_Course_Department.Course_Department_Date, 
dbo.Tbl_Department.Department_Name    
FROM         dbo.Tbl_Department INNER JOIN    
                      dbo.Tbl_Course_Department ON dbo.Tbl_Department.Department_Id = dbo.Tbl_Course_Department.Department_Id INNER JOIN    
                      dbo.Tbl_Course_Category ON dbo.Tbl_Course_Department.Course_Category_Id = dbo.Tbl_Course_Category.Course_Category_Id    
     
where Tbl_Course_Department.Course_Department_Status=0 and    
      Tbl_Course_Category.Course_Category_Status=0 and    
         Tbl_Department.Department_Status=0 and    
      --Tbl_Course_Department.course_Department_Id=@Course_Department_Id   
      Tbl_Course_Department.Department_Id=@Course_Department_Id    
END
    ');
END;
