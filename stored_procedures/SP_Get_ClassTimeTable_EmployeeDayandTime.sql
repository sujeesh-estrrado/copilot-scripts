IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_ClassTimeTable_EmployeeDayandTime]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_ClassTimeTable_EmployeeDayandTime]  
 (@WeekDay_Settings_Id bigint,  
  @Class_Timings_Id bigint,
  @Employee_Id bigint)
AS   
BEGIN  
 SELECT CT.*,E.Employee_FName+'' ''+Employee_LName as EmployeeName,  
 S.Subject_Name  
 FROM  Tbl_Class_TimeTable CT  
 INNER JOIN Tbl_Employee E On E.Employee_Id=CT.Employee_Id  
 INNER JOIN Tbl_Semester_Subjects SS On SS.Semester_Subject_Id=CT.Semster_Subject_Id  
 INNER JOIN  Tbl_Department_Subjects D On D.Department_Subject_Id=SS.Department_Subjects_Id  
 INNER JOIN Tbl_Subject S On S.Subject_Id=D.Subject_Id  
  
 WHERE CT.WeekDay_Settings_Id=@WeekDay_Settings_Id   
  and CT.Class_Timings_Id=@Class_Timings_Id
  and CT.Employee_Id=@Employee_Id
  and CT.Class_TimeTable_Status=0  
  
END 

    ');
END;
