IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAllWeekDayPeriods_TimeTable]') 
    AND type = N'P'
)
BEGIN
    EXEC('
 CREATE PROCEDURE [dbo].[SP_GetAllWeekDayPeriods_TimeTable]   
    @Class_Timings_Id BIGINT,
    @Dept_Id BIGINT,
    @BatchID BIGINT,
	@WeekDay_Id BIGINT
AS          
BEGIN     
 
SELECT DISTINCT
    CT.Customize_ClassTimingId AS Class_Timings_Id,
    CT.Is_BreakTime,
    D.WeekDay_Settings_Id AS WeekDay_Id   
FROM Tbl_Customize_ClassTiming CT 
INNER JOIN Tbl_Customize_ClassTimingMapping CCT 
    ON CT.Customize_ClassTimingId = CCT.Customize_ClassTimingId 	
INNER JOIN Tbl_Day_Week D 
    ON CCT.Department_Id = D.Dept_Id   
WHERE 
    CT.Customize_ClassTimingId = @Class_Timings_Id
    AND D.Dept_Id = @Dept_Id
    AND CCT.Batch_Id = @BatchID
	AND D.Checked_Status=1
ORDER BY D.WeekDay_Settings_Id



END')
END;
