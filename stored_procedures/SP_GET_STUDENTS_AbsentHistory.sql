IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_STUDENTS_AbsentHistory]')
    AND type = N'P'
)
BEGIN
    EXEC('
create procedure [dbo].[SP_GET_STUDENTS_AbsentHistory]  --1,''09/25/2017'',6,''Monday'',2 --8,''08/22/2016 00:00:00'',2,''MONDAY''--22,''2/29/2016'',19,''MONDAY''              
(@SemesterSubjectId bigint,                    
@AbsentDate datetime,                
@ClassTimingId bigint,@WeekdayName varchar(50),  
@Candidate_Id bigint      
)                      
                     
as      
      
 begin                       
                 
select distinct CPD.Candidate_Id,CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+                      
CPD.Candidate_Lname as [CandidateName],D.Course_Code+'' ''+CBD.Batch_Code as Intake,CS.Semester_Code,D.Department_Name,                      
CDM.Duration_Mapping_Id,S.Subject_Id,D.Department_Id,SS.Semester_Subject_Id,S.Subject_Name,SA.Absent_Type,SA.Remark,                
--WS.WeekDay_Name,                
case SA.Absent_Type                
when ''absent'' then ''Absent''                
else ''Present''            --Select right(@n, len(@n)-1)    
end as AbsentType,SA.Remark,-- right(SA.Remark,len(SA.Remark)-1) as Remark,               
SA.Absent_Date,                
(select Hour_Name+''-''+convert(char(5),Start_Time,108)+''-''+convert(char(5),End_Time,108)   
from dbo.Tbl_ClassTimings where Class_Timings_Id=@ClassTimingId)as ClassTimings                
                      
--select S.Subject_Name,S.Subject_Id                      
from dbo.Tbl_Semester_Subjects SS inner join dbo.Tbl_Department_Subjects DS                      
on DS.Department_Subject_Id=SS.Department_Subjects_Id                      
inner join dbo.Tbl_Subject S on S.Subject_Id=DS.Subject_Id                      
                      
--where SS.Semester_Subject_Id=28                      
                      
inner join dbo.Tbl_Student_Subject_Child SSC on SSC.Subject_Id=S.Subject_Id                      
inner join dbo.Tbl_Student_Subject_Master SSM on SSM.Student_Subject_Map_Master=SSC.Student_Subject_Map_Master                      
inner join dbo.Tbl_Student_Semester SSe on SSe.Candidate_Id=SSM.Candidate_Id and SSe.Student_Semester_Current_Status=1                     
inner join dbo.Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=SSM.Candidate_Id                      
inner join dbo.Tbl_Course_Duration_Mapping CDM on CDM.Duration_Mapping_Id=SSM.Duration_Mapping_Id                      
inner join dbo.Tbl_Course_Duration_PeriodDetails CDP on CDP.Duration_Period_Id=CDM.Duration_Period_Id                      
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CDP.Batch_Id                      
inner join dbo.Tbl_Course_Semester CS on CS.Semester_Id=CDP.Semester_Id                      
inner join dbo.Tbl_Department D on D.Department_Id = SSM.Department_Id                      
inner join dbo.Tbl_Class_TimeTable CT on CT.Duration_Mapping_Id=CDM.Duration_Mapping_Id                
--inner join  dbo.Tbl_ClassTimings CTi on CTi.Class_Timings_Id=CT.Class_Timings_Id                  
--CT.Semster_Subject_Id=SS.Semester_Subject_Id                    
inner join dbo.Tbl_WeekDay_Batch_Mapping WBM on WBM.WeekDay_Batch_Mapping_Id =CT.WeekDay_Settings_Id                    
inner join dbo.Tbl_WeekDay_Settings WS on WS.WeekDay_Settings_Id=WBM.WeekDay_Settings_Id                
left join  dbo.Tbl_Student_Absence SA on SA.Candidate_Id=CPD.Candidate_Id and SA.Absent_Date=@AbsentDate                
and SA.Class_Timings_Id=@ClassTimingId                
                      
where SS.Semester_Subject_Id=@SemesterSubjectId and UPPER(WS.WeekDay_Name)=UPPER(@WeekdayName)  
and SA.Candidate_Id= @Candidate_Id            
--@SemesterSubjectId                 
--and SA.Absent_Date=''1/26/2016 12:00:00 AM''                
--@AbsentDate                
--and UPPER(WS.WeekDay_Name)=UPPER(@WeekdayName)                     
                    
--79 and upper(WS.WeekDay_Name)=''MONDAY''                    
end   
  
  
--select *from Tbl_Student_Absence

    ')
END;
