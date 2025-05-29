IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_WeekDaysAndTimings]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure  [dbo].[SP_GetAll_WeekDaysAndTimings]
AS  
BEGIN
SELECT 
Class_Timings_Id as ID,
Hour_Name,  
LTRIM(RIGHT(CONVERT(VARCHAR(20), Start_Time, 100), 7)) AS Start_Time,  
LTRIM(RIGHT(CONVERT(VARCHAR(20), End_Time, 100), 7)) AS End_Time,  
Is_BreakTime,
WeekDay_Settings_Id,
WeekDay_Name  
FROM  Tbl_ClassTimings C,Tbl_WeekDay_Settings W 
WHERE  ClassTiming_Status=0 and  WeekDay_Status=1
  
END
    ')
END
