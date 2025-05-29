IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_ClassTimeTable_ByEmployee_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Get_ClassTimeTable_ByEmployee_Report]                       
 (@WeekDay_Settings_Id BIGINT    ,                                
  @Employee_Id         BIGINT          
  --@Program_Id BIGINT,
  --@Batch_Id BIGINT
)                                    
AS                                     
BEGIN  


     --25/03/2025-FOR THE SCENARIO WHERE THE SAME EMPLOYEE CAN HAVE CLASSES AT THE SAME TIME FOR DIFFERENT PROGRAMS  
     
     
--    SELECT DISTINCT
--CT.Class_Timings_Id ,
--CT.merged_status,
--CT.Day_Id,
--SSC.Start_Time,
--ssc.End_Time,
--DE.Course_Code+''-''+DE.Department_Name AS Department,
--C.Course_code+''-''+C.Course_Name   AS Subject_Name,
--concat(CBD.Batch_Code , ''-'' , cs.Semester_Code) AS BatchSemester,
----DE.Department_Name+''-''+C.Course_code+''-''+CBD.Batch_Code     AS Class
--DE.Department_Name + ''<br />'' + 
--    C.Course_code + ''<br />'' +
--    CASE 
--        WHEN CHARINDEX(''-'', CBD.Batch_Code) > 0 
--             THEN SUBSTRING(CBD.Batch_Code, 1, CHARINDEX(''-'', CBD.Batch_Code) - 1)
--        ELSE CBD.Batch_Code
--    END AS Class 
--FROM Tbl_Class_TimeTable           CT
--INNER JOIN Tbl_New_Course          C   ON CT.Semster_Subject_Id=C.Course_Id
--INNER JOIN Tbl_Course_Department   CD  ON CD.Course_Department_Id=CT.Department_Id                  
--INNER JOIN Tbl_Course_Category         CC  ON CC.Course_Category_Id=CD.Course_Category_Id             
--INNER JOIN Tbl_Department          DE  ON DE.Department_Id=CT.Department_Id 
--INNER JOIN Tbl_Semester_Subjects     SS  ON CT.Semster_Subject_Id=SS.Department_Subjects_Id
--INNER JOIN Tbl_Course_Duration_PeriodDetails CDP ON CT.Duration_Mapping_Id=CDP.Duration_Period_Id
--INNER JOIN Tbl_Course_Batch_Duration CBD ON CDP.Batch_Id=CBD.Batch_Id
--INNER JOIN Tbl_Course_Semester         CS  ON CS.Semester_Id = CDP.Semester_Id 
--Inner JOIN Tbl_Customize_ClassTiming SSC on CT.Class_Timings_Id=ssc.Customize_ClassTimingId
--   WHERE  CT.Employee_Id=@Employee_Id
--    AND   CT.Day_Id=@WeekDay_Settings_Id   
--  AND   CT.Del_Status=0

----Issue  where the same day different timing data taking 
--WITH ClassData AS (
--    SELECT DISTINCT
--        CT.Class_Timings_Id,
--      CT.Day_Id,
--        DE.Course_Code + ''-'' + DE.Department_Name AS Department,
--        C.Course_code + ''-'' + C.Course_Name AS Subject_Name,
--        CONCAT(CBD.Batch_Code, ''-'', CS.Semester_Code) AS BatchSemester,
--        DE.Department_Name + ''<br />'' + 
--            C.Course_code + ''<br />'' +
--            CASE 
--                WHEN CHARINDEX(''-'', CBD.Batch_Code) > 0 
--                    THEN SUBSTRING(CBD.Batch_Code, 1, CHARINDEX(''-'', CBD.Batch_Code) - 1)
--                ELSE CBD.Batch_Code
--            END AS Class,
--        CT.merged_status
--    FROM Tbl_Class_TimeTable CT
--    INNER JOIN Tbl_New_Course C ON CT.Semster_Subject_Id = C.Course_Id
--    INNER JOIN Tbl_Course_Department CD ON CD.Course_Department_Id = CT.Department_Id                  
--    INNER JOIN Tbl_Department DE ON DE.Department_Id = CT.Department_Id 
--    INNER JOIN Tbl_Semester_Subjects SS ON CT.Semster_Subject_Id = SS.Department_Subjects_Id
--    INNER JOIN Tbl_Course_Duration_PeriodDetails CDP ON CT.Duration_Mapping_Id = CDP.Duration_Period_Id
--    INNER JOIN Tbl_Course_Batch_Duration CBD ON CDP.Batch_Id = CBD.Batch_Id
--    INNER JOIN Tbl_Course_Semester CS ON CS.Semester_Id = CDP.Semester_Id                   
--    WHERE CT.Employee_Id = @Employee_Id
--        AND CT.Day_Id = @WeekDay_Settings_Id   
--        AND CT.Del_Status = 0
--),
--MergedClasses AS (
--    SELECT 
--        STUFF((
--            SELECT DISTINCT '','' + CAST(CD2.Class_Timings_Id AS VARCHAR(10))
--            FROM ClassData CD2
--            WHERE CD2.merged_status = 1
--            FOR XML PATH(''''), TYPE).value(''.'', ''NVARCHAR(MAX)''), 1, 1, '''') AS Class_Timings_Id,
        
--        STUFF((
--            SELECT DISTINCT '','' + CD2.Department
--            FROM ClassData CD2
--            WHERE CD2.merged_status = 1
--            FOR XML PATH(''''), TYPE).value(''.'', ''NVARCHAR(MAX)''), 1, 1, '''') AS Department,
        
--        STUFF((
--            SELECT DISTINCT '','' + CD2.Subject_Name
--            FROM ClassData CD2
--            WHERE CD2.merged_status = 1
--            FOR XML PATH(''''), TYPE).value(''.'', ''NVARCHAR(MAX)''), 1, 1, '''') AS Subject_Name,
        
--        STUFF((
--            SELECT DISTINCT '','' + CD2.BatchSemester
--            FROM ClassData CD2
--            WHERE CD2.merged_status = 1
--            FOR XML PATH(''''), TYPE).value(''.'', ''NVARCHAR(MAX)''), 1, 1, '''') AS BatchSemester,
        
--        STUFF((
--            SELECT DISTINCT ''<br />'' + CD2.Class
--            FROM ClassData CD2
--            WHERE CD2.merged_status = 1
--            FOR XML PATH(''''), TYPE).value(''.'', ''NVARCHAR(MAX)''), 1, 6, '''') AS Class,
        
--        1 AS merged_status
--    FROM ClassData
--    WHERE merged_status = 1
--    GROUP BY merged_status
--),
--NonMergedClasses AS (
--    SELECT 
--        CAST(Class_Timings_Id AS VARCHAR(10)) AS Class_Timings_Id,
--        Department,
--        Subject_Name,
--        BatchSemester,
--        Class,
--        0 AS merged_status
--    FROM ClassData
--    WHERE merged_status = 0
--    GROUP BY Class_Timings_Id, Department, Subject_Name, BatchSemester, Class
--)

---- Final result
--SELECT 
--    Class_Timings_Id,
--    Department,
--    Subject_Name,
--    BatchSemester,
--    Class,
--    merged_status
--FROM (
--    SELECT * FROM MergedClasses
--    UNION ALL
--    SELECT * FROM NonMergedClasses
--) AS CombinedResults
--ORDER BY 
--    CASE WHEN merged_status = 1 THEN 0 ELSE 1 END,
--    Class_Timings_Id;


WITH ClassData AS (
    SELECT DISTINCT
        CT.Class_Timings_Id,
        CT.Day_Id,
        DE.Course_Code + ''-'' + DE.Department_Name AS Department,
        C.Course_code + ''-'' + C.Course_Name AS Subject_Name,
        CONCAT(CBD.Batch_Code, ''-'', CS.Semester_Code) AS BatchSemester,
        DE.Department_Name + ''<br />'' + 
            C.Course_code + ''<br />'' +
            CASE 
                WHEN CHARINDEX(''-'', CBD.Batch_Code) > 0 
                    THEN SUBSTRING(CBD.Batch_Code, 1, CHARINDEX(''-'', CBD.Batch_Code) - 1)
                ELSE CBD.Batch_Code
            END AS Class,
        CT.merged_status,
      
        FORMAT(CC.Start_Time, ''hh:mm tt'') AS Start_Time,  
        FORMAT(CC.End_Time, ''hh:mm tt'') AS End_Time
    FROM Tbl_Class_TimeTable CT
    INNER JOIN Tbl_New_Course C ON CT.Semster_Subject_Id = C.Course_Id
    INNER JOIN Tbl_Course_Department CD ON CD.Course_Department_Id = CT.Department_Id                  
    INNER JOIN Tbl_Department DE ON DE.Department_Id = CT.Department_Id 
    INNER JOIN Tbl_Semester_Subjects SS ON CT.Semster_Subject_Id = SS.Department_Subjects_Id
    INNER JOIN Tbl_Course_Duration_PeriodDetails CDP ON CT.Duration_Mapping_Id = CDP.Duration_Period_Id
    INNER JOIN Tbl_Course_Batch_Duration CBD ON CDP.Batch_Id = CBD.Batch_Id
    INNER JOIN Tbl_Course_Semester CS ON CS.Semester_Id = CDP.Semester_Id   
    INNER JOIN Tbl_Customize_ClassTiming CC ON CT.Class_Timings_Id = CC.Customize_ClassTimingId
    WHERE CT.Employee_Id = @Employee_Id
        AND CT.Day_Id = @WeekDay_Settings_Id   
        AND CT.Del_Status = 0
),
MergedClasses AS (
    SELECT 
        STUFF((SELECT DISTINCT '','' + CAST(CD2.Class_Timings_Id AS VARCHAR(10))
               FROM ClassData CD2
               WHERE CD2.merged_status = 1 
               AND CD2.Start_Time = CD.Start_Time -- Ensure same start time
               AND CD2.End_Time = CD.End_Time     -- Ensure same end time
               FOR XML PATH(''''), TYPE).value(''.'', ''NVARCHAR(MAX)''), 1, 1, '''') AS Class_Timings_Id,
        
        STUFF((SELECT DISTINCT '','' + CD2.Department
               FROM ClassData CD2
               WHERE CD2.merged_status = 1 
               AND CD2.Start_Time = CD.Start_Time 
               AND CD2.End_Time = CD.End_Time
               FOR XML PATH(''''), TYPE).value(''.'', ''NVARCHAR(MAX)''), 1, 1, '''') AS Department,
        
        STUFF((SELECT DISTINCT '','' + CD2.Subject_Name
               FROM ClassData CD2
               WHERE CD2.merged_status = 1 
               AND CD2.Start_Time = CD.Start_Time 
               AND CD2.End_Time = CD.End_Time
               FOR XML PATH(''''), TYPE).value(''.'', ''NVARCHAR(MAX)''), 1, 1, '''') AS Subject_Name,
        
        STUFF((SELECT DISTINCT '','' + CD2.BatchSemester
               FROM ClassData CD2
               WHERE CD2.merged_status = 1 
               AND CD2.Start_Time = CD.Start_Time 
               AND CD2.End_Time = CD.End_Time
               FOR XML PATH(''''), TYPE).value(''.'', ''NVARCHAR(MAX)''), 1, 1, '''') AS BatchSemester,
        
        STUFF((SELECT DISTINCT ''<br />'' + CD2.Class
               FROM ClassData CD2
               WHERE CD2.merged_status = 1 
               AND CD2.Start_Time = CD.Start_Time 
               AND CD2.End_Time = CD.End_Time
               FOR XML PATH(''''), TYPE).value(''.'', ''NVARCHAR(MAX)''), 1, 6, '''') AS Class,
        
        1 AS merged_status,
        CD.Start_Time,
        CD.End_Time
    FROM ClassData CD
    WHERE CD.merged_status = 1
    GROUP BY CD.Start_Time, CD.End_Time
),
NonMergedClasses AS (
    SELECT 
        CAST(Class_Timings_Id AS VARCHAR(10)) AS Class_Timings_Id,
        Department,
        Subject_Name,
        BatchSemester,
        Class,
        0 AS merged_status,
        Start_Time,
        End_Time
    FROM ClassData
    WHERE merged_status = 0
    GROUP BY Class_Timings_Id, Department, Subject_Name, BatchSemester, Class, Start_Time, End_Time
)
 
SELECT 
    Class_Timings_Id,
    Department,
    Subject_Name,
    BatchSemester,
    Class,
    merged_status,
    Start_Time,
    End_Time
FROM (
    SELECT * FROM MergedClasses
    UNION ALL
    SELECT * FROM NonMergedClasses
) AS CombinedResults
ORDER BY 
    CASE WHEN merged_status = 1 THEN 0 ELSE 1 END,
    Start_Time, End_Time, Class_Timings_Id;

END
    ');
END;
