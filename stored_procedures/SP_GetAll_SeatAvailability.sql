IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_SeatAvailability]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_GetAll_SeatAvailability] 

AS

BEGIN
SELECT     dbo.Tbl_Course_Capacity.Course_Capacity_Total, dbo.Tbl_Course_Capacity.Avaliable, dbo.Tbl_Course_Capacity.Trend_Id, 
                      dbo.Tbl_Course_Category.Course_Category_Name, dbo.Tbl_Course_Category.Course_Category_Id, dbo.Tbl_Course_Trend.Trend, dbo.Tbl_Course_Trend.Start_Period,
                       dbo.Tbl_Course_Trend.End_Period
FROM         dbo.Tbl_Course_Capacity INNER JOIN
                      dbo.Tbl_Course_Trend ON dbo.Tbl_Course_Capacity.Trend_Id = dbo.Tbl_Course_Trend.Trend_Id INNER JOIN
                      dbo.Tbl_Course_Category ON dbo.Tbl_Course_Trend.Course_Category_Id = dbo.Tbl_Course_Category.Course_Category_Id
WHERE     (dbo.Tbl_Course_Capacity.Del_Capacity_Status = 0) AND (dbo.Tbl_Course_Trend.Del_Trend_Status = 0) AND (dbo.Tbl_Course_Category.Course_Category_Status = 0)
END
    ')
END
