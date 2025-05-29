IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_ClassTimeTable_ByWeekAndSem_For_Student]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Get_ClassTimeTable_ByWeekAndSem_For_Student]                       
 (@WeekDay_Settings_Id bigint,                                    
  @Duration_Mapping_Id bigint ,
  @DepartmentId bigint ,
  @CandidateId bigint
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
 C.Course_Name											  AS Subject_Name,
 C.Course_Id											  AS Subject_Id,
 C.Course_code											  AS Subject_Code,   
 (Select Count(CN.Course_Id) From Tbl_New_Course CN
 Where CN.Course_Id=C.Course_Id )                         AS ChildCount ,                          
(select Hour_Name from   Tbl_Customize_ClassTiming CC
 where CC.Customize_ClassTimingId=CT.Class_Timings_Id  )  AS Class_Timings_Name,                          
(select Hour_Name from   Tbl_Customize_ClassTiming CC
 where CC.Customize_ClassTimingId=CT.Class_Timings_Id ) +'' Period - ''+ C.Course_Name AS Subject_Class_Timings,
  C.Course_code + ''<br />'' + 
    E.Employee_FName  + ''<br />''  
    AS Class 
 FROM 
 Tbl_Class_TimeTable				    CT
 INNER JOIN Tbl_Employee			    E  ON E.Employee_Id=CT.Employee_Id  
 INNER JOIN Tbl_New_Course              C  ON C.Course_Id=CT.Semster_Subject_Id   
 inner join tbl_New_Admission           A  ON CT.Department_Id=A.Department_Id
 INNER JOIN Tbl_Candidate_Personal_Det  CD ON A.New_Admission_Id=CD.New_Admission_Id
 WHERE CT.Day_Id                    =@WeekDay_Settings_Id                                     
 AND   CT.Duration_Mapping_Id	    =@Duration_Mapping_Id 
 AND   CT.Department_Id             =@DepartmentId
 --AND   CD.Candidate_Id				=@CandidateId
 AND   CT.Class_TimeTable_Status=0     
 AND   E.Employee_Status =0     
 
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
 where CC.Customize_ClassTimingId=CT.Class_Timings_Id ) +'' Period - ''+ C.Course_Name AS Subject_Class_Timings,
  C.Course_code + ''<br />'' + 
    E.Employee_FName  + ''<br />''  
    AS Class 
 FROM 
 Tbl_Class_TimeTable				    CT
 INNER JOIN Tbl_Employee			    E  ON E.Employee_Id=CT.Employee_Id  
 INNER JOIN Tbl_New_Course              C  ON C.Course_Id=CT.Semster_Subject_Id   
 inner join tbl_New_Admission           A  ON CT.Department_Id=A.Department_Id
 INNER JOIN Tbl_Candidate_Personal_Det  CD ON A.New_Admission_Id=CD.New_Admission_Id
 WHERE CT.Day_Id                    =@WeekDay_Settings_Id                                     
 AND   CT.Duration_Mapping_Id	    =@Duration_Mapping_Id 
 AND   CT.Department_Id             =@DepartmentId
 --AND   CD.Candidate_Id				=@CandidateId
 AND   CT.Class_TimeTable_Status=0     
 AND   E.Employee_Status =0     
 
order by   Class_Timings_Id asc


end             
                  
                               
                       
                                    
END 

    ');
END;
