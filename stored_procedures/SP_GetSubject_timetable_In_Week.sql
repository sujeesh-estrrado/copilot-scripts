IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetSubject_timetable_In_Week]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure [dbo].[SP_GetSubject_timetable_In_Week]   
 (@Semester_Subject_Id bigint,            
  @Duration_Mapping_Id bigint,
@WeekDay_Settings_Id bigint            
)            
AS             
BEGIN            
 SELECT         
 CT.*,E.Employee_FName+'' ''+Employee_LName as EmployeeName,            
 S.Subject_Name, S.Subject_Id,      
 S.Subject_Code,         
(Select Count(Subject_Id) From Tbl_Subject  Where Parent_Subject_Id=S.Subject_Id) As ChildCount ,  
(select Hour_Name from  dbo.Tbl_ClassTimings where Class_Timings_Id=CT.Class_Timings_Id) as Class_Timings_Name,  
  S.Subject_Name+''-''+ (select Hour_Name from  dbo.Tbl_ClassTimings where Class_Timings_Id=CT.Class_Timings_Id) as Subject_Class_Timings     
 FROM  Tbl_Class_TimeTable CT            
 INNER JOIN Tbl_Employee E On E.Employee_Id=CT.Employee_Id            
 INNER JOIN Tbl_Semester_Subjects SS On SS.Semester_Subject_Id=CT.Semster_Subject_Id            
 INNER JOIN  Tbl_Department_Subjects D On D.Department_Subject_Id=SS.Department_Subjects_Id            
 INNER JOIN Tbl_Subject S On S.Subject_Id=D.Subject_Id            
          
 WHERE SS.Semester_Subject_Id=@Semester_Subject_Id             
  and CT.Duration_Mapping_Id=@Duration_Mapping_Id            
  and CT.Class_TimeTable_Status=0   and   WeekDay_Settings_Id=  @WeekDay_Settings_Id       
            
END
    ');
END;
