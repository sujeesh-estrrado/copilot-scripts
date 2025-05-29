IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAllWeekDayPeriods_CLASS_TimeTable]') 
    AND type = N'P'
)
BEGIN
    EXEC('
 CREATE PROCEDURE [dbo].[SP_GetAllWeekDayPeriods_CLASS_TimeTable]   
    @Class_Timings_Id BIGINT,
    @Dept_Id BIGINT,
    @BatchID BIGINT,
	@WeekDay_Id BIGINT
AS          
BEGIN     
 
--SELECT DISTINCT
--    CT.Customize_ClassTimingId AS Class_Timings_Id,
--    CT.Is_BreakTime,
--    D.WeekDay_Settings_Id AS WeekDay_Id   
--FROM Tbl_Customize_ClassTiming CT 
--LEFT JOIN Tbl_Customize_ClassTimingMapping CCT 
--    ON CT.Customize_ClassTimingId = CCT.Customize_ClassTimingId 	
--LEFT JOIN Tbl_Day_Week D 
--    ON CCT.Department_Id = D.Dept_Id  
--		INNER JOIN Tbl_Class_TimeTable TCC ON D.WeekDay_Settings_Id=TCC.Day_Id 
--WHERE 
--    --CT.Customize_ClassTimingId = @Class_Timings_Id
--	 TCC.Class_Timings_Id= @Class_Ti1mings_Id
--    AND CCT.Department_Id = @Dept_Id
--    AND CCT.Batch_Id = @BatchID 
--	AND TCC.Del_Status=0

	 
--	 SELECT DISTINCT
--    CT.Customize_ClassTimingId AS Class_Timings_Id,
--    CT.Is_BreakTime,
--    D.WeekDay_Settings_Id AS WeekDay_Id   
--FROM Tbl_Customize_ClassTiming CT 
--LEFT JOIN Tbl_Customize_ClassTimingMapping CCT 
--    ON CT.Customize_ClassTimingId = CCT.Customize_ClassTimingId 	
--LEFT JOIN Tbl_Day_Week D 
--    ON CCT.Department_Id = D.Dept_Id  
--INNER JOIN Tbl_Class_TimeTable TCC 
--    ON D.WeekDay_Settings_Id = TCC.Day_Id  
--    AND CT.Customize_ClassTimingId = TCC.Class_Timings_Id  
--WHERE 
--    CCT.Department_Id = @Dept_Id
--    AND CCT.Batch_Id = @BatchID 
--    AND TCC.Del_Status = 0
--    AND TCC.Class_Timings_Id = @Class_Timings_Id;   

	  


	WITH UniqueDays AS (
    -- Get unique days for the department and duration mapping ID
    SELECT DISTINCT Day_Id 
    FROM Tbl_Class_TimeTable 
    WHERE Department_Id = @Dept_Id 
      AND Duration_Mapping_Id = @BatchID
) 
SELECT 
    @Class_Timings_Id AS Class_Timings_Id,
    UD.Day_Id,
    CT.Is_BreakTime
FROM UniqueDays UD
LEFT JOIN Tbl_Customize_ClassTiming CT 
    ON CT.Customize_ClassTimingId = @Class_Timings_Id
ORDER BY UD.Day_Id;

 
END ')
END;
