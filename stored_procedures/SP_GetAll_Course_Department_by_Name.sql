IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Course_Department_by_Name]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_Course_Department_by_Name](@Course_Department_Name varchar(300))  
  
AS  
  
BEGIN  
            SELECT     dbo.Tbl_Course_Department.Course_Department_Id
   --Tbl_Course_Department.Course_Department_Name  
                       
            FROM                  dbo.Tbl_Course_Category INNER JOIN  
                      dbo.Tbl_Course_Department ON dbo.Tbl_Course_Category.Course_Category_Id = dbo.Tbl_Course_Department.Course_Category_Id  
  
  
       where Tbl_Course_Department.Course_Department_Status=0 and  
                 Tbl_Course_Category.Course_Category_Status=0 
--and Tbl_Course_Department.Course_Department_Name=@Course_Department_Name ;  
     
END
');
END;