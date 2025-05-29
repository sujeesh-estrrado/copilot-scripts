IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_ClassTiming_Export]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Get_ClassTiming_Export]                       
(                                    
  @Department_Id bigint,
  @Batch_Id BIGINT
)                                    
AS                                     
BEGIN   
    SELECT 
        CT.Class_Timings_Id,
        E.Employee_Id,
        E.Employee_FName + '' '' + E.Employee_LName AS EmployeeName,    
        CT.Semster_Subject_Id,
        C.Course_Name AS Subject_Name,
        C.Course_Id AS Subject_Id,
        C.Course_code AS Subject_Code,   
        (SELECT COUNT(CN.Course_Id) 
         FROM Tbl_New_Course CN
         WHERE CN.Course_Id = C.Course_Id) AS ChildCount,                          
        (SELECT Hour_Name 
         FROM Tbl_Customize_ClassTiming CC
         WHERE CC.Customize_ClassTimingId = CT.Class_Timings_Id) AS Class_Timings_Name,   
        (SELECT LTRIM(RIGHT(CONVERT(VARCHAR(20), CC.Start_Time, 100), 7)) 
         FROM Tbl_Customize_ClassTiming CC
         WHERE CC.Customize_ClassTimingId = CT.Class_Timings_Id) AS StartTime,
        (SELECT LTRIM(RIGHT(CONVERT(VARCHAR(20), CC.End_Time, 100), 7)) 
         FROM Tbl_Customize_ClassTiming CC
         WHERE CC.Customize_ClassTimingId = CT.Class_Timings_Id) AS EndTime,
        (SELECT 
            CC.Hour_Name + '' '' + 
            LTRIM(RIGHT(CONVERT(VARCHAR(20), CC.Start_Time, 100), 7)) + ''-'' + 
            LTRIM(RIGHT(CONVERT(VARCHAR(20), CC.End_Time, 100), 7)) 
         FROM Tbl_Customize_ClassTiming CC
         WHERE CC.Customize_ClassTimingId = CT.Class_Timings_Id) AS Subject_Class_Timings,              
        W.WeekDay_Name AS Day
    FROM 
        Tbl_Class_TimeTable CT
    INNER JOIN Tbl_Employee E ON E.Employee_Id = CT.Employee_Id
    INNER JOIN Tbl_Semester_Subjects SS ON SS.Semester_Subject_Id = CT.Semster_Subject_Id 
    INNER JOIN Tbl_Department_Subjects D ON D.Department_Subject_Id = SS.Department_Subjects_Id                                      
    INNER JOIN Tbl_New_Course C ON C.Course_Id = D.Subject_Id
    INNER JOIN Tbl_WeekDay_Settings W ON CT.Day_Id = W.WeekDay_Settings_Id
    WHERE 
        D.Course_Department_Id = @Department_Id
        AND CT.Duration_Mapping_Id = @Batch_Id                                  
        AND CT.Class_TimeTable_Status = 0     
        AND E.Employee_Status = 0                           
    ORDER BY   
        CT.Class_Timings_Id ASC;
END;
    ');
END;
