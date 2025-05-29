IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Course_Trend]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_Course_Trend]  
  
AS  
  
BEGIN  
  
   
SELECT  dbo.Tbl_Course_Trend.Trend_Id, dbo.Tbl_Course_Trend.Course_Level_Id,  
  dbo.Tbl_Course_Trend.Course_Category_Id, dbo.Tbl_Course_Trend.Course_Department_Id,  
        dbo.Tbl_Course_Trend.Trend, dbo.Tbl_Course_Trend.Start_Period,   
  dbo.Tbl_Course_Trend.End_Period, dbo.Tbl_Course_Level.Course_Level_Name,   
        --dbo.Tbl_Course_Department.Course_Department_Name,  
  dbo.Tbl_Course_Category.Course_Category_Name  
FROM    dbo.Tbl_Course_Category   
  
INNER JOIN dbo.Tbl_Course_Trend ON dbo.Tbl_Course_Category.Course_Category_Id = dbo.Tbl_Course_Trend.Course_Category_Id   
INNER JOIN dbo.Tbl_Course_Department ON dbo.Tbl_Course_Trend.Course_Department_Id = dbo.Tbl_Course_Department.Course_Department_Id   
INNER JOIN dbo.Tbl_Course_Level ON dbo.Tbl_Course_Trend.Course_Level_Id = dbo.Tbl_Course_Level.Course_Level_Id  
  
WHERE dbo.Tbl_Course_Trend.Del_Trend_Status=0  
     
END
');
END;