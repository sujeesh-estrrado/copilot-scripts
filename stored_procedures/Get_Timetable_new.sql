-- Create Get_Timetable_new procedure if it does not exist
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_Timetable_new]') 
    AND type = N'P'
)
BEGIN
    EXEC('
            
CREATE procedure [dbo].[Get_Timetable_new]-- ''MONDAY'',12,29,15    
@WeekDay_Name varchar(20),    
@Class_Timings_Id int,    
@WeekDay_Settings_Id int,    
@Duration_Mapping_Id bigint    
    
as    
begin           
           
           
 SELECT  distinct                           
 --CT.*,            
 CT.Class_TimeTable_Id,WeekDay_Name,    
 Room_Name as RoomName,        
 CT.Semster_Subject_Id,            
 CT.Class_Timings_Id,            
 CT.Employee_Id,            
 E.Employee_FName+'' ''+Employee_LName as EmployeeName,                                
 S.Subject_Name, S.Subject_Id,                          
 S.Subject_Code,        
                          
(Select Count(Subject_Id) From Tbl_Subject  Where Parent_Subject_Id=S.Subject_Id) As ChildCount ,                      
(select Hour_Name from  dbo.Tbl_ClassTimings where Class_Timings_Id=CT.Class_Timings_Id) as Class_Timings_Name,                      
(select Hour_Name from  dbo.Tbl_ClassTimings where Class_Timings_Id=CT.Class_Timings_Id) +'' Period - ''+ S.Subject_Name as Subject_Class_Timings                         
     
     
 --,(select WeekDay_Name from  dbo.Tbl_WeekDay_Settings w inner join    
 --Tbl_WeekDay_Batch_Mapping wb on ws.WeekDay_Settings_Id=wbm.WeekDay_Settings_Id     
 --inner join dbo.Tbl_Class_TimeTable wbm on wbm.Duration_Mapping_Id =CT.Duration_Mapping_Id      
 --where wb.WeekDay_Status=1  )     
     
 --as weekname                         
     
     
 FROM  Tbl_Class_TimeTable CT                                
 INNER JOIN Tbl_Employee E On E.Employee_Id=CT.Employee_Id                                
 INNER JOIN Tbl_Semester_Subjects SS On SS.Semester_Subject_Id=CT.Semster_Subject_Id                                
 INNER JOIN  Tbl_Department_Subjects D On D.Department_Subject_Id=SS.Department_Subjects_Id                                
 INNER JOIN Tbl_Subject S On S.Subject_Id=D.Subject_Id                                
 inner join  dbo.Tbl_WeekDay_Batch_Mapping wbm on wbm.Duration_Mapping_Id =CT.Duration_Mapping_Id         
 LEFT join dbo.Tbl_Class_Allocation CA ON CA.Duration_Mapping_Id=CT.Duration_Mapping_Id      
 LEFT join dbo.Tbl_Room R on r.Room_Id=CA.Room_Id      
 left join dbo.Tbl_WeekDay_Settings as ws on ws.WeekDay_Settings_Id=wbm.WeekDay_Settings_Id      
--inner join dbo.Tbl_ClassTimings c on c.Duration_Mapping_Id =CT.Duration_Mapping_Id     
 WHERE     
 CT.WeekDay_Settings_Id=@WeekDay_Settings_Id    
 --wbm.WeekDay_Batch_Mapping_Id=@WeekDay_Settings_Id    
 and    
  CT.Duration_Mapping_Id=@Duration_Mapping_Id                                
 and CT.Class_TimeTable_Status=0 and E.Employee_Status =0      
 and WeekDay_Name=@WeekDay_Name       
  and  CT.Class_Timings_Id=@Class_Timings_Id  AND wbm.WeekDay_Status=1    
--order by   CT.lass_Timings_Id asc       
end
    ')
END;
GO
