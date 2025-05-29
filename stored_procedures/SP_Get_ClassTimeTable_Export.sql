IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_ClassTimeTable_Export]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Get_ClassTimeTable_Export]                       
 (                                    
  @Employee_Id bigint                               
)                                    
AS                                     
BEGIN   



 SELECT 
 E.Employee_FName+'' ''+Employee_LName                        AS EmployeeName   ,
 LTRIM(RIGHT(CONVERT(VARCHAR(20), TCC.Start_Time, 100), 7)) AS Start_Time,
 LTRIM(RIGHT(CONVERT(VARCHAR(20), TCC.End_Time, 100), 7))   AS End_Time,
 C.Course_Name											    AS Subject_Name, 
 C.Course_code											    AS Subject_Code,
 WD.WeekDay_Name												AS Day
FROM 
Tbl_Class_TimeTable CT  
 INNER JOIN Tbl_Employee			 E  ON E.Employee_Id=CT.Employee_Id                                     
 INNER JOIN Tbl_New_Course           C  ON C.Course_Id=CT.Semster_Subject_Id 
 INNER JOIN Tbl_Customize_ClassTiming  TCC ON CT.Class_Timings_Id=TCC.Customize_ClassTimingId
 INNER JOIN Tbl_WeekDay_Settings      WD ON CT.Day_Id=WD.WeekDay_Settings_Id
 WHERE CT.Employee_Id =69                
  AND CT.Class_TimeTable_Status=0 

  
                       
                                    
END 
    ');
END;
