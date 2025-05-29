IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAllWeek_DayPeriods_EmployeeReport]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[SP_GetAllWeek_DayPeriods_EmployeeReport]  
--@Class_Timings_Id bigint ,
@Class_Timings_Id NVARCHAR(MAX),
@EmployeeID BIGINT,
--@BatchID BIGINT,
@Location_Id BIGINT     =0   
AS          
BEGIN   
 --25/03/2025-FOR THE SCENARIO WHERE THE SAME EMPLOYEE CAN HAVE CLASSES AT THE SAME TIME FOR DIFFERENT PROGRAMS  
	 
--WITH EmpDays AS (
--    SELECT DISTINCT Day_Id
--    FROM Tbl_Class_TimeTable
--    WHERE Employee_Id = @EmployeeID
--      AND Del_Status = 0
--)
 
--SELECT 
--    CCT.Customize_ClassTimingId AS Class_Timings_Id,
--    CCT.Is_BreakTime
--FROM Tbl_Customize_ClassTiming CCT
--CROSS JOIN EmpDays
--WHERE 
--    CCT.ClassTiming_Status = 0 
--    AND CCT.Customize_ClassTimingId = @Class_Timings_Id
--ORDER BY CCT.Customize_ClassTimingId;

DECLARE @TempTable TABLE (ClassTimingsID BIGINT);

INSERT INTO @TempTable (ClassTimingsID)
SELECT CAST(value AS BIGINT) 
FROM dbo.SplitStringFunction(@Class_Timings_Id, '','');
 
WITH EmpDays AS (
    -- Get distinct days for the employee
    SELECT DISTINCT Day_Id
    FROM Tbl_Class_TimeTable
    WHERE Employee_Id = @EmployeeID
      AND Del_Status = 0
),
ClassTimingsPerDay AS (
    -- Get ClassTimings for each day (with duplicates if needed)
    SELECT 
        ED.Day_Id,
        CCT.Customize_ClassTimingId AS Class_Timings_Id,
        CCT.Is_BreakTime
    FROM EmpDays ED
    CROSS JOIN Tbl_Customize_ClassTiming CCT
    WHERE 
        CCT.ClassTiming_Status = 0 
        AND CCT.Customize_ClassTimingId IN (SELECT ClassTimingsID FROM @TempTable)
),
UniqueClassTimings AS (
    -- Get the comma-separated list of ClassTimings (once)
    SELECT 
        STRING_AGG(CAST(Class_Timings_Id AS VARCHAR(MAX)), '','') AS Class_Timings_List,
        MAX(CAST(Is_BreakTime AS INT)) AS Is_BreakTime_Flag
    FROM (
        SELECT DISTINCT Class_Timings_Id, Is_BreakTime
        FROM ClassTimingsPerDay
    ) AS DistinctTimings
)

-- Repeat the same ClassTimings for each day
SELECT 
    UC.Class_Timings_List AS Class_Timings_Id,
    CAST(UC.Is_BreakTime_Flag AS BIT) AS Is_BreakTime
FROM EmpDays ED
CROSS JOIN UniqueClassTimings UC
ORDER BY ED.Day_Id;



END')
END;
