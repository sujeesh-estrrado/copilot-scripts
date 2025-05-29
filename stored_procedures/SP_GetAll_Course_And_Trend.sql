IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Course_And_Trend]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_Course_And_Trend]

AS

BEGIN


SELECT  dbo.Tbl_Course_Category.Course_Category_Id, dbo.Tbl_Course_Category.Course_Category_Name, dbo.Tbl_Course_Category.Course_Category_Descripition, 
                      dbo.Tbl_Course_Category.Course_Category_Date, dbo.Tbl_Course_Category.Course_Category_Status, dbo.Tbl_Course_Trend.Trend_Id, 
                      dbo.Tbl_Course_Trend.Course_Level_Id, dbo.Tbl_Course_Trend.Course_Category_Id AS Expr1, dbo.Tbl_Course_Trend.Course_Department_Id, 
                      dbo.Tbl_Course_Trend.Trend, dbo.Tbl_Course_Trend.Start_Period, dbo.Tbl_Course_Trend.End_Period, dbo.Tbl_Course_Trend.Del_Trend_Status
FROM  dbo.Tbl_Course_Category LEFT OUTER JOIN
                      dbo.Tbl_Course_Trend ON dbo.Tbl_Course_Category.Course_Category_Id = dbo.Tbl_Course_Trend.Course_Category_Id
WHERE (dbo.Tbl_Course_Category.Course_Category_Status = 0 OR
                      dbo.Tbl_Course_Category.Course_Category_Status IS NULL) AND (dbo.Tbl_Course_Trend.Del_Trend_Status = 0 OR
                      dbo.Tbl_Course_Trend.Del_Trend_Status IS NULL)

END
');
END;