IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Course_Category_Name]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_Course_Category_Name]      
      
AS      
      
BEGIN      
      
SELECT    *
FROM       
                      dbo.Tbl_Course_Category 
where Course_Category_Status=0  
         
END


');
END;