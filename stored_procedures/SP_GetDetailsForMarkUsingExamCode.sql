IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetDetailsForMarkUsingExamCode]') 
    AND type = N'P'
)
BEGIN
    EXEC('
   
CREATE procedure [dbo].[SP_GetDetailsForMarkUsingExamCode]   --''Adroit-def-11/2017-MT'' ,''--Select--''     
              
(@Examcode varchar(100),@marker varchar(50))              
              
AS BEGIN              
Declare @grading varchar(100)            
Declare @assesmentType varchar(100)            
Declare @assesmentCode varchar(100)   
--Declare @Batch_Codes varchar(100)   
--Declare @Sem_Codes varchar(100)   
 --set  @Batch_Codes=(select distinct Convert(varchar(50),Intake_Number,103)              
 -- from Tbl_Exam_Mark_Entry_Child where ExamCode=@Examcode)-- and (Marker=@marker))  
 -- set  @Sem_Codes=(select distinct Convert(varchar(50),Sem_Number,103)              
 -- from Tbl_Exam_Mark_Entry_Child where ExamCode=@Examcode) --and (Marker=@marker))  
              
  select distinct ECC.AssesmentType,ECM.Subject_Description,ECM.Campus,ECM.Assessment_Code,GC.ExamDescription,GC.ExamTerm,Convert(varchar(10),GC.ExamDate,103) ExamDate from Tbl_Exam_Code_Child ECC inner join             
  Tbl_Exam_Code_Master ECM on ECM.Exam_Code_Master_Id=ECC.Exam_Code_Master_Id            
  inner join Tbl_GroupChangeExamDates GC on GC.ExamCode=ECC.Exam_Code_final              
   where ECC.Exam_Code_final=@Examcode            
   -- dt1    
              
  (select distinct Candidate_Id,Course_Code,IC_Passport IC,Name,'' '' as Batch_Code,'' '' AS Semester_Code,--(select @Batch_Codes) as Batch_Code,(select @Sem_Codes) as Semester_Code,
  Marks Mark,Actual_Marks ActualMark,Grade,Pass_Fail Pass             
  from Tbl_Exam_Mark_Entry_Child where ExamCode=@Examcode )--and (Marker=@marker))            
 union all          
  (select distinct(SEM.Candidate_Id)Candidate_Id,D.Course_Code,CPD.AdharNumber IC,CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname as NAME,CBD.Batch_Code,CS.Semester_Code,            
  0 Mark,0 ActualMark,'' '' Grade,'' '' Pass            
   from Tbl_StudentExamSubjectMaster SEM            
  inner join Tbl_StudentExamSubjectsChild SCC on SEM.StudentExamSubjectMasterId=SCC.StudentExamSubjectMasterId            
  inner join Tbl_Department D on D.Department_Id=SEM.Department_Id            
  inner join Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=SEM.Candidate_Id            
  inner join Tbl_Course_Duration_Mapping CDM on CDM.Duration_Mapping_Id=SEM.Duration_Mapping_Id            
  inner join Tbl_Course_Duration_PeriodDetails PD on PD.Duration_Period_Id=CDM.Duration_Period_Id            
  inner join Tbl_Course_Semester CS on CS.Semester_Id=PD.Semester_Id            
  inner join Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=PD.Batch_Id             
  where SEM.Candidate_Id not in(select Candidate_Id  from Tbl_Exam_Mark_Entry_Child where ExamCode=@Examcode )--and (Marker=@marker))             
              
    and SCC.ExamCode=@Examcode)            
  -- dt2            
              
 set @grading = (select distinct(GradingScherme) from Tbl_StudentExamSubjectsChild where ExamCode=@Examcode)            
 set @assesmentType=(select distinct(AssesmentType) from Tbl_Exam_Code_Child where Exam_Code_final=@Examcode)            
 set @assesmentCode=(select distinct(Assessment_Code) from Tbl_Exam_Code_Master ECMM            
 inner join Tbl_Exam_Code_Child ECCM on ECMM.Exam_Code_Master_Id=ECCM.Exam_Code_Master_Id            
  where Exam_Code_final=@Examcode)            
              
 select distinct(GSSS.Grade) Grade, GSSS.[From],GSSS.[To],GSSS.Pass,ACC.GivenMarks,ACC.Assessment_Perc,AT.Assesment_Type,ACM.Assessment_Code,GSS.Grade_Scheme         
 from Tbl_GradingScheme GSS             
 inner join Tbl_GradeSchemeSetup GSSS on GSS.Grade_Scheme_Id=GSSS.Grade_Scheme_Id         
 inner join Tbl_Subject_Master SM on SM.Grading_Scheme=GSS.Grade_Scheme        
 inner join Tbl_Subject S on S.Subject_Master_Code_Id=SM.Subject_Master_Code_Id        
 inner join Tbl_Assessment_Code_Master ACM on ACM.Assessment_Code = S.Assessment_Code        
 inner join Tbl_Assessment_Code_Child ACC on ACM.Assessment_Code_Id = ACC.Assessment_Code_Id              
 inner join Tbl_Assessment_Type AT on AT.Assessment_Type_Id=ACC.Assessment_Type_Id            
 where GSS.Grade_Scheme=@grading and AT.Assesment_Type=@assesmentType and ACM.Assessment_Code=@assesmentCode      
 
 select distinct UnBoundGrade,UnBoundDesc,Pass from Tbl_GradeSpecial U      
 inner join Tbl_GradingScheme UG on UG.Grade_Scheme_Id=U.Grade_Scheme_Id where UG.Grade_Scheme=@grading             
              
              
END  ');
END;
