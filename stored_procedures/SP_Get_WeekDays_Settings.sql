IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_WeekDay_TimeTable]')
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Get_WeekDay_TimeTable]   
    @Class_Timings_Id BIGINT,
    @Dept_Id BIGINT,
    @BatchID BIGINT,
    @WeekDay_Id BIGINT
AS          
BEGIN      

SELECT DISTINCT
    CT.Customize_ClassTimingId AS Class_Timings_Id,
    CT.Is_BreakTime,
    CCT.Days_Id AS WeekDay_Id   
FROM Tbl_Customize_ClassTiming CT 
INNER JOIN Tbl_Customize_ClassTimingMapping CCT 
    ON CT.Customize_ClassTimingId = CCT.Customize_ClassTimingId 
WHERE 
    CT.Customize_ClassTimingId = @Class_Timings_Id
    AND CCT.Department_Id = @Dept_Id
    AND CCT.Batch_Id = @BatchID



END

    ')
END
GO
