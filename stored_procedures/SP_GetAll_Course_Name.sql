IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Course_Name]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_Course_Name]    
    
AS    
    
BEGIN    
SELECT     dbo.Tbl_Course_Category.Course_Category_Name, dbo.Tbl_Course_Category.Course_Category_Id
FROM         dbo.Tbl_Course_Category 
    
       where dbo.Tbl_Course_Category.Course_Category_Status=0   
                  
order by dbo.Tbl_Course_Category.Course_Category_Name  
       
END
');
END;