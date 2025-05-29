IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Course_Category_BY_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Course_Category_BY_Id]  
  
(@Course_Category_Id bigint)      
      
AS      
      
BEGIN      
      
  
      
      
      
    SELECT      dbo.Tbl_Course_Category.Course_Category_Id, dbo.Tbl_Course_Category.Course_level_Id,               
                      dbo.Tbl_Course_Category.Course_Category_Name, dbo.Tbl_Course_Category.Course_Category_Descripition,               
                      dbo.Tbl_Course_Category.Course_Category_Date, dbo.Tbl_Course_Category.Course_Category_Status,        
                      Tbl_Course_Category.Program_Code,Tbl_Course_Category.Program_Email,dbo.Tbl_Course_Category.Program_Director        
                                    
FROM        Tbl_Course_Category   
  
where Tbl_Course_Category.Course_Category_Status=0     and dbo.Tbl_Course_Category.Course_Category_Id=@Course_Category_Id        
order by dbo.Tbl_Course_Category.Course_Category_Name asc   
      
      
       
END
    ');
END;
