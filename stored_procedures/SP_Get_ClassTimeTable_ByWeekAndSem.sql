IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_ClassTimeTable_ByWeekAndSem]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Get_ClassTimeTable_ByWeekAndSem]                       
 (@WeekDay_Settings_Id bigint,                                    
  @Duration_Mapping_Id bigint ,
  @DepartmentId bigint  
)                                    
AS                                     
BEGIN                       
declare @Status bigint                   
set @Status=(select top 1 WeekDay_Settings_Id AS Day_Id from Tbl_Day_Week where  Dept_Id=@DepartmentId  )                  
if(@Status>0)                  
begin                  
 SELECT 
 CT.Class_Timings_Id ,
 E.Employee_Id,
 E.Employee_FName                                         AS EmployeeName,    
 CT.Semster_Subject_Id,
 C.Course_code+''-''+C.Course_Name						  AS Subject_Name,
 C.Course_Id											  AS Subject_Id,
  C.Course_code						                      AS Subject_Code,   
 (Select Count(CN.Course_Id) From Tbl_New_Course CN
 Where CN.Course_Id=C.Course_Id )                         AS ChildCount ,                          
(select Hour_Name from   Tbl_Customize_ClassTiming CC
 where CC.Customize_ClassTimingId=CT.Class_Timings_Id  )  AS Class_Timings_Name,                          
(select Hour_Name from   Tbl_Customize_ClassTiming CC
 where CC.Customize_ClassTimingId=CT.Class_Timings_Id ) +'' Period - ''+ C.Course_Name AS Subject_Class_Timings,
 C.Course_code+''-''+C.Course_Name + ''<br />'' + 
    E.Employee_FName  + ''<br />''  
    AS Class 
 FROM 
 Tbl_Class_TimeTable				 CT
 INNER JOIN Tbl_Employee			 E  ON E.Employee_Id=CT.Employee_Id
 --INNER JOIN Tbl_Semester_Subjects    SS ON SS.Semester_Subject_Id=CT.Semster_Subject_Id 
 INNER JOIN Tbl_New_Course           C  ON C.Course_Id=CT.Semster_Subject_Id                                    

 WHERE CT.Day_Id                    =@WeekDay_Settings_Id                                     
 AND   CT.Duration_Mapping_Id	    =@Duration_Mapping_Id 
 AND   CT.Department_Id             =@DepartmentId
 AND   CT.Class_TimeTable_Status=0     
 AND   E.Employee_Status =0      
 AND   CT.Del_Status=0
order by   Class_Timings_Id asc

end                  
else                  
begin   


SELECT 
 CT.Class_Timings_Id ,
 E.Employee_Id,
 E.Employee_FName                                         AS EmployeeName,    
 CT.Semster_Subject_Id,
 C.Course_Name											  AS Subject_Name,
 C.Course_Id											  AS Subject_Id,
 C.Course_code											  AS Subject_Code,   
 (Select Count(CN.Course_Id) From Tbl_New_Course CN
 Where CN.Course_Id=C.Course_Id )                         AS ChildCount ,                          
(select Hour_Name from   Tbl_Customize_ClassTiming CC
 where CC.Customize_ClassTimingId=CT.Class_Timings_Id  )  AS Class_Timings_Name,                          
(select Hour_Name from   Tbl_Customize_ClassTiming CC
 where CC.Customize_ClassTimingId=CT.Class_Timings_Id ) +''Period - ''+ C.Course_Name AS Subject_Class_Timings,
  C.Course_code + ''<br />'' + 
    E.Employee_FName  + ''<br />''  
    AS Class 
 FROM 
 Tbl_Class_TimeTable				 CT
 INNER JOIN Tbl_Employee			 E  ON E.Employee_Id=CT.Employee_Id
 --INNER JOIN Tbl_Semester_Subjects    SS ON SS.Semester_Subject_Id=CT.Semster_Subject_Id 
 INNER JOIN Tbl_New_Course           C  ON C.Course_Id=CT.Semster_Subject_Id                                    

 WHERE CT.Day_Id                    =@WeekDay_Settings_Id                                     
 AND   CT.Duration_Mapping_Id	    =@Duration_Mapping_Id 
 AND   CT.Department_Id             =@DepartmentId
 AND   CT.Class_TimeTable_Status=0     
 AND   E.Employee_Status =0     
 AND   CT.Del_Status=0
order by   Class_Timings_Id asc

end             
                  
                               
                       
                                    
END

    ');
END;
