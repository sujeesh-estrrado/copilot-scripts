IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Class_TimeTable_Export]') 
    AND type = N'P'
)
BEGIN
    EXEC('
 CREATE PROCEDURE [dbo].[SP_Get_Class_TimeTable_Export]                       
 (                                    
  @Department_Id bigint     ,
  @Batch_Id BIGINT
)                                    
AS                                     
BEGIN   
 
 SELECT 
 E.Employee_FName                       AS EmployeeName   ,
 TCC.Hour_Name,
 LTRIM(RIGHT(CONVERT(VARCHAR(20), TCC.Start_Time, 100), 7)) AS Start_Time,
 LTRIM(RIGHT(CONVERT(VARCHAR(20), TCC.End_Time, 100), 7))   AS End_Time, 
 C.Course_code											    AS Subject_Code,
 WD.WeekDay_Name												AS Day,
  DE.Course_Code ,
 DE.Course_Code+''-''+DE.Department_Name AS Department,
C.Course_Name   AS Subject_Name,

concat(CBD.Batch_Code , ''-'' , cs.Semester_Code) AS BatchSemester
  
FROM 
Tbl_Class_TimeTable CT  
 INNER JOIN Tbl_Employee			 E  ON E.Employee_Id=CT.Employee_Id                                     
 INNER JOIN Tbl_New_Course           C  ON C.Course_Id=CT.Semster_Subject_Id 
 INNER JOIN Tbl_Customize_ClassTiming  TCC ON CT.Class_Timings_Id=TCC.Customize_ClassTimingId
 INNER JOIN Tbl_WeekDay_Settings      WD ON CT.Day_Id=WD.WeekDay_Settings_Id
 INNER JOIN Tbl_Course_Department	 CD  ON CD.Course_Department_Id=CT.Department_Id                  
INNER JOIN Tbl_Course_Category		 CC  ON CC.Course_Category_Id=CD.Course_Category_Id             
INNER JOIN Tbl_Department			 DE  ON DE.Department_Id=CT.Department_Id
INNER JOIN Tbl_Course_Batch_Duration CBD ON CT.Duration_Mapping_Id=CBD.Batch_Id
INNER JOIN Tbl_Course_Duration_PeriodDetails CDP ON CT.Duration_Mapping_Id=CDP.Batch_Id
INNER JOIN Tbl_Course_Semester	     CS  ON CS.Semester_Id = CDP.Semester_Id                   
 WHERE CT.Department_Id =@Department_Id  
 and CT.Duration_Mapping_Id=@Batch_Id
  AND CT.Class_TimeTable_Status=0 

  
                       
                                    
END 
')
END;
