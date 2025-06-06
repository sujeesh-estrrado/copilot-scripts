IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_Absentdate_by_Student]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_Get_Absentdate_by_Student] --2,''2017-04-19 00:00:00.000''  
@Candidate_Id bigint,  
@Absent_Date varchar(100)   
as    
begin    
    
    
select  distinct   
CPD.Candidate_Id,CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+                                  
CPD.Candidate_Lname as CandidateName,SA.Candidate_Id,SA.Duration_Mapping_Id,SA.Absent_Date,SA.Class_Timings_Id,    
case SA.Absent_Type                            
when ''absent'' then ''Absent''                            
else ''Presnt''                            
end as AbsentType    
--SA.Absent_Type    
,SA.Course_Department_Id,SA.Subject_Id,SA.Remark,ST.Subject_Name as SubjectName,
(select Hour_Name from  dbo.Tbl_ClassTimings where Class_Timings_Id=CT.Class_Timings_Id) as Class_Timings_Name,      
(select convert(varchar,Start_Time,108) from  dbo.Tbl_ClassTimings where Class_Timings_Id=CT.Class_Timings_Id) as Start_Time,      
(select  convert(varchar,End_Time,108) from  dbo.Tbl_ClassTimings where Class_Timings_Id=CT.Class_Timings_Id) as End_Time
    
from Tbl_Student_Absence SA    
inner join dbo.Tbl_Semester_Subjects s on s.Semester_Subject_Id=SA.Subject_Id    
inner join dbo.Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=SA.Candidate_Id  
INNER JOIN Tbl_Department_Subjects DS on DS.Department_Subject_Id=S.Department_Subjects_Id 
inner join Tbl_Subject ST on DS.Subject_Id=ST.Subject_Id
INNER JOIN  Tbl_Class_TimeTable CTi on CTi.Class_Timings_Id= s.Semester_Subject_Id
inner join Tbl_ClassTimings CT on CT.Class_Timings_Id= CT.Class_Timings_Id

where SA.Candidate_Id=@Candidate_Id  and SA.Absent_Date=@Absent_Date 
            
            


end
    ')
END
