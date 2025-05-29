IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAllWeekDayPeriods_TimeTable_Reports]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_GetAllWeekDayPeriods_TimeTable_Reports]   
    @Class_Timings_Id BIGINT,
    @Dept_Id BIGINT,
    @BatchID BIGINT,
	@WeekDay_Id BIGINT
AS          
BEGIN     
 
SELECT DISTINCT
    CT.Customize_ClassTimingId AS Class_Timings_Id,
    CT.Is_BreakTime  
FROM Tbl_Customize_ClassTiming CT 
INNER JOIN Tbl_Customize_ClassTimingMapping CCT 
    ON CT.Customize_ClassTimingId = CCT.Customize_ClassTimingId 	
INNER JOIN Tbl_Class_TimeTable TCC 
    ON CT.Customize_ClassTimingId = TCC.Class_Timings_Id   
WHERE 
    CT.Customize_ClassTimingId = @Class_Timings_Id
    AND TCC.Department_Id = @Dept_Id
    AND TCC.Duration_Mapping_Id = @BatchID 



END
')
END;
