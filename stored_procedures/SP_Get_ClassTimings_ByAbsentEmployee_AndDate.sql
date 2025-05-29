IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_ClassTimings_ByAbsentEmployee_AndDate]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_ClassTimings_ByAbsentEmployee_AndDate]     
(@Employee_Id bigint,    
 @WeekDay Varchar(10),    
 @WeekDayCode Varchar(10)    
)    
AS     
BEGIN    
    
SELECT  CT.Duration_Mapping_Id,    
CT.WeekDay_Settings_Id,    
CT.Class_Timings_Id,    
CT.Employee_Id,    
WS.WeekDay_Name,    
WS.WeekDay_Code,    
CTi.Hour_Name,    
CBD.Batch_Code+''/''+CC.Course_Category_Name+''/''+D.Department_Name+''/''+CS.Semester_Code  as Department    
    
    
    
    
FROM Tbl_Class_TimeTable CT    
    
INNER JOIN Tbl_WeekDay_Settings WS On CT.WeekDay_Settings_Id=WS.WeekDay_Settings_Id    
INNER JOIN Tbl_ClassTimings CTi ON CT.Class_Timings_Id=CTi.Class_Timings_Id    
INNER JOIN Tbl_Employee E On CT.Employee_Id=E.Employee_Id    
    
INNER JOIN Tbl_Course_Duration_Mapping CDM on CDM.Duration_Mapping_Id=CT.Duration_Mapping_Id    
INNER JOIN Tbl_Course_Duration_PeriodDetails CDP on CDP.Duration_Period_Id=CDM.Duration_Period_Id    
INNER JOIN Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CDP.Batch_Id    
INNER JOIN Tbl_Course_Semester CS on CS.Semester_Id=CDP.Semester_Id    
INNER JOIN Tbl_Course_Department CD on CD.Course_Department_Id=CDM.Course_Department_Id    
INNER JOIN Tbl_Department D on D.Department_Id=CD.Department_Id    
Inner Join Tbl_Course_Category CC On CC.Course_Category_Id=CD.Course_Category_Id    
   
    
WHERE CT.Employee_Id=@Employee_Id and WeekDay_Name=@WeekDay and WeekDay_Code=@WeekDayCode    
      and Class_TimeTable_Status=0    
    
END
    ');
END;
