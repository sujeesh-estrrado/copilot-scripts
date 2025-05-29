IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_SUBJECTBYEMPLOYEE_Attendance]')
    AND type = N'P'
)
BEGIN
    EXEC('
   create PROCEDURE [dbo].[SP_GET_SUBJECTBYEMPLOYEE_Attendance]     
(@EmployeeId bigint=0,
@Department BIGINT,
@DurationMappingId BIGINT,
@Location_Id bigint=0,
@WeekdayName VARCHAR(50) =null
 
 )   
        
AS BEGIN 

--SELECT DISTINCT 
--    CCT.Customize_ClassTimingId AS Class_Timings_Id,
--    S.Course_Name + ''-'' + LTRIM(RIGHT(CONVERT(VARCHAR(20), CCT.Start_Time, 100), 7)) + ''-'' + LTRIM(RIGHT(CONVERT(VARCHAR(20), CCT.End_Time, 100), 7)) AS Subject_Name,
--    S.Course_Id AS Subject_Id,
--    CT.Semster_Subject_Id 
--FROM dbo.Tbl_Class_TimeTable CT
--INNER JOIN dbo.Tbl_New_Course S ON S.Course_Id = CT.Semster_Subject_Id
--INNER JOIN Tbl_Customize_ClassTiming CCT ON CT.Class_Timings_Id = CCT.Customize_ClassTimingId
--INNER JOIN Tbl_WeekDay_Settings WS ON WS.WeekDay_Settings_Id = CT.Day_Id
--WHERE CT.Employee_Id = @EmployeeId
----AND CT.Duration_Mapping_Id=@DurationMappingId
----AND CT.Department_Id=@Department
--AND UPPER(WS.WeekDay_Name) = UPPER(@WeekdayName);

if(@EmployeeId=0)
begin
SELECT DISTINCT 
   -- CCT.Customize_ClassTimingId AS Class_Timings_Id,
    S.Course_Name AS Subject_Name,
    S.Course_Id AS Subject_Id,
    CT.Semster_Subject_Id,
    CT.Semster_Subject_Id  AS UniqueId
FROM dbo.Tbl_Class_TimeTable CT
INNER JOIN dbo.Tbl_New_Course S ON S.Course_Id = CT.Semster_Subject_Id
--INNER JOIN Tbl_Customize_ClassTiming CCT ON CT.Class_Timings_Id = CCT.Customize_ClassTimingId
INNER JOIN Tbl_WeekDay_Settings WS ON WS.WeekDay_Settings_Id = CT.Day_Id
WHERE 
--CT.Employee_Id = @EmployeeId
--  AND 
  CT.Duration_Mapping_Id = @DurationMappingId
  AND CT.Department_Id = @Department
end
else
begin
SELECT DISTINCT 
   -- CCT.Customize_ClassTimingId AS Class_Timings_Id,
    S.Course_Name AS Subject_Name,
    S.Course_Id AS Subject_Id,
    CT.Semster_Subject_Id,
    CT.Semster_Subject_Id  AS UniqueId
FROM dbo.Tbl_Class_TimeTable CT
INNER JOIN dbo.Tbl_New_Course S ON S.Course_Id = CT.Semster_Subject_Id
--INNER JOIN Tbl_Customize_ClassTiming CCT ON CT.Class_Timings_Id = CCT.Customize_ClassTimingId
INNER JOIN Tbl_WeekDay_Settings WS ON WS.WeekDay_Settings_Id = CT.Day_Id
WHERE CT.Employee_Id = @EmployeeId
  AND CT.Duration_Mapping_Id = @DurationMappingId
  AND CT.Department_Id = @Department
 -- AND UPPER(WS.WeekDay_Name) = UPPER(@WeekdayName);

 end

END

    ')
END;
