IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_ClassTimeTable_ByEmployee]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Get_ClassTimeTable_ByEmployee]                       
 (@WeekDay_Settings_Id BIGINT    ,                                
  @Employee_Id         BIGINT          
  --@Program_Id BIGINT,
  --@Batch_Id BIGINT
)                                    
AS                                     
BEGIN  
 
SELECT 
CT.Class_Timings_Id													 AS Class_Timings_Id,
CT.Semster_Subject_Id,
E.Employee_Id,
E.Employee_FName+'' ''+Employee_LName									 AS EmployeeName,  
C.Course_Name														 AS Subject_Name,
C.Course_Id															 AS Subject_Id,
C.Course_code														 AS Subject_Code, 
 (Select Count(CN.Course_Id) From Tbl_New_Course CN
 Where CN.Course_Id=C.Course_Id )                                    AS ChildCount ,
CC.Course_Category_Name+'' ''+DE.Department_Name+''-''+Semester_Code     AS Class ,
CT.Duration_Mapping_Id												 AS Batch_Id,
CDM.Course_Department_Id											 AS Course_Department_Id
FROM 
 Tbl_Class_TimeTable CT   
 INNER JOIN Tbl_Employee						E   ON E.Employee_Id=CT.Employee_Id                
 INNER JOIN Tbl_Semester_Subjects				SS  ON SS.Semester_Subject_Id=CT.Semster_Subject_Id              
 INNER JOIN Tbl_Department_Subjects				D   ON D.Department_Subject_Id=SS.Department_Subjects_Id 
 INNER JOIN Tbl_New_Course						C   ON C.Course_Id=D.Subject_Id 
 INNER JOIN Tbl_Course_Duration_Mapping			CDM ON CDM.Duration_Mapping_Id=CT.Duration_Mapping_Id               
 INNER JOIN Tbl_Course_Duration_PeriodDetails   CDP ON CDM.Duration_Period_Id=CDP.Duration_Period_Id                
 INNER JOIN Tbl_Course_Semester					CS  ON CS.Semester_Id=CDP.Semester_Id                
 INNER JOIN Tbl_Course_Department			    CD  ON CD.Course_Department_Id=CDM.Course_Department_Id                  
 INNER JOIN Tbl_Course_Category				    CC  ON CC.Course_Category_Id=CD.Course_Category_Id             
 INNER JOIN Tbl_Department						DE  ON DE.Department_Id=CD.Department_Id  
 WHERE CT.WeekDay_Settings_Id=@WeekDay_Settings_Id 
  AND  CT.Employee_Id=@Employee_Id                
  AND  CT.Class_TimeTable_Status=0 

  UNION 

 SELECT 
CT.Class_Timings_Id												     AS Class_Timings_Id,
CT.Semster_Subject_Id,
E.Employee_Id,
E.Employee_FName+'' ''+Employee_LName									 AS EmployeeName,  
C.Course_Name														 AS Subject_Name, 
C.Course_Id															 AS Subject_Id,
C.Course_code														 AS Subject_Code, 
 (Select Count(CN.Course_Id) From Tbl_New_Course CN
 Where CN.Course_Id=C.Course_Id )                                    AS ChildCount ,
CC.Course_Category_Name+'' ''+DE.Department_Name+''-''+Semester_Code     AS Class ,

CT.Duration_Mapping_Id												 AS Batch_Id,
CDM.Course_Department_Id											 AS Course_Department_Id
FROM 
 Tbl_Class_TimeTable CT   
 INNER JOIN Tbl_Employee						E   ON E.Employee_Id=CT.Employee_Id                
 INNER JOIN Tbl_Semester_Subjects				SS  ON SS.Semester_Subject_Id=CT.Semster_Subject_Id              
 INNER JOIN Tbl_Department_Subjects				D   ON D.Department_Subject_Id=SS.Department_Subjects_Id 
 INNER JOIN Tbl_New_Course						C   ON C.Course_Id=D.Subject_Id 
 INNER JOIN Tbl_Course_Duration_Mapping			CDM ON CDM.Duration_Mapping_Id=CT.Duration_Mapping_Id               
 INNER JOIN Tbl_Course_Duration_PeriodDetails   CDP ON CDM.Duration_Period_Id=CDP.Duration_Period_Id                
 INNER JOIN Tbl_Course_Semester					CS  ON CS.Semester_Id=CDP.Semester_Id                
 INNER JOIN Tbl_Course_Department			    CD  ON CD.Course_Department_Id=CDM.Course_Department_Id                  
 INNER JOIN Tbl_Course_Category				    CC  ON CC.Course_Category_Id=CD.Course_Category_Id             
 INNER JOIN Tbl_Department						DE  ON DE.Department_Id=CD.Department_Id 
 WHERE
      CT.Day_Id=@WeekDay_Settings_Id                 
  AND CT.Employee_Id=@Employee_Id   
  AND CT.Class_TimeTable_Status=0 
                  
   
                       
                                    
END
')
END;
