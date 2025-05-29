IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_ClassTimeTable_Bydate]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_ClassTimeTable_Bydate]              
  @date datetime ,        
    @Duration_Mapping_Id bigint                
                                 
AS                                   
BEGIN                                  
 SELECT                               
 CT.*,                
CT.WeekDay,              
LTRIM(RIGHT(CONVERT(VARCHAR(20), CT.Start_Time, 100), 10)) AS StartTime,                
LTRIM(RIGHT(CONVERT(VARCHAR(20), CT.End_Time, 100), 10)) AS EndTime,                  
E.Employee_FName+'' ''+Employee_LName as EmployeeName,                                  
 S.Subject_Name, S.Subject_Id,                            
 S.Subject_Code,                              
(Select Count(Subject_Id) From Tbl_Subject  Where Parent_Subject_Id=S.Subject_Id) As ChildCount ,                        
(select Hour_Name from  dbo.Tbl_ClassTimings where Class_Timings_Id=CT.Class_Timings_Id) as Class_Timings_Name,                        
   (select Hour_Name from  dbo.Tbl_ClassTimings where Class_Timings_Id=CT.Class_Timings_Id) +'' Period - ''+ S.Subject_Name as Subject_Class_Timings                           
 FROM  Tbl_Class_TimeTable CT                                  
 INNER JOIN Tbl_Employee E On E.Employee_Id=CT.Employee_Id                                  
 INNER JOIN Tbl_Semester_Subjects SS On SS.Semester_Subject_Id=CT.Semster_Subject_Id                                  
 INNER JOIN  Tbl_Department_Subjects D On D.Department_Subject_Id=SS.Department_Subjects_Id                                  
 INNER JOIN Tbl_Subject S On S.Subject_Id=D.Subject_Id                                  
                                
 WHERE  CT.Class_TimeTable_Status=0     and E.Employee_Status =0 and   Date=@date and  CT.Duration_Mapping_Id=@Duration_Mapping_Id      
--  and  Assigned_Status=''ASSIGNED''      
order by  Class_Timings_Name asc                       
                                  
END
');
END;