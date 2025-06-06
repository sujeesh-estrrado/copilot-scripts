IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Timetable_by_Student]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
 CREATE procedure [dbo].[Proc_Timetable_by_Student] --2,1,1  
 @WeekDay_Settings_Id bigint,  
 @Duration_Mapping_Id bigint,  
 @Candidate_Id bigint  
 as  
 begin  
   
 SELECT  distinct                       
 --CT.*,        
         
 CT.Semster_Subject_Id,        
 CT.Class_Timings_Id,        
 CT.Employee_Id,        
 E.Employee_FName+'' ''+Employee_LName as EmployeeName,CT.WeekDay_Settings_Id,CT.Duration_Mapping_Id,sd.Candidate_Id,CT.Class_TimeTable_Status,                            
 S.Subject_Name, S.Subject_Id,                      
 S.Subject_Code,                         
(Select Count(Subject_Id) From Tbl_Subject  Where Parent_Subject_Id=S.Subject_Id) As ChildCount ,                  
(select Hour_Name from  dbo.Tbl_ClassTimings where Class_Timings_Id=CT.Class_Timings_Id) as Class_Timings_Name,    
(select convert(varchar,Start_Time,108) from  dbo.Tbl_ClassTimings where Class_Timings_Id=CT.Class_Timings_Id) as Start_Time,    
(select  convert(varchar,End_Time,108) from  dbo.Tbl_ClassTimings where Class_Timings_Id=CT.Class_Timings_Id) as End_Time,                   
   (select Hour_Name from  dbo.Tbl_ClassTimings where Class_Timings_Id=CT.Class_Timings_Id) +'' Period - ''+ S.Subject_Name as Subject_Class_Timings                     
 FROM  Tbl_Class_TimeTable CT                            
 INNER JOIN Tbl_Employee E On E.Employee_Id=CT.Employee_Id                            
 INNER JOIN Tbl_Semester_Subjects SS On SS.Semester_Subject_Id=CT.Semster_Subject_Id                            
 INNER JOIN  Tbl_Department_Subjects D On D.Department_Subject_Id=SS.Department_Subjects_Id                            
 INNER JOIN Tbl_Subject S On S.Subject_Id=D.Subject_Id                            
 inner join  dbo.Tbl_WeekDay_Batch_Mapping wbm on wbm.Duration_Mapping_Id =CT.Duration_Mapping_Id     
  INNER JOIN Tbl_Student_Semester sd on ss.Duration_Mapping_Id=CT.Duration_Mapping_Id                       
 WHERE CT.WeekDay_Settings_Id=@WeekDay_Settings_Id                             
  and CT.Duration_Mapping_Id=@Duration_Mapping_Id   
  and sd.Candidate_Id=@Candidate_Id                                 
  and CT.Class_TimeTable_Status=0     and E.Employee_Status =0                  
  
end
    ')
END
