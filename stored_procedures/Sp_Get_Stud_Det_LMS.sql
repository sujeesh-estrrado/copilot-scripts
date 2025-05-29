IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Stud_Det_LMS]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure  [dbo].[Sp_Get_Stud_Det_LMS]  
  
@Candidateid int  
  
As  
begin  
  
select P.Candidate_Fname+'' ''+Candidate_Mname+'' ''+Candidate_Lname as CandidateFullname,P.New_Admission_Id,N.Department_Id,  
D.Department_Name,D.Course_Code,SS.Duration_Mapping_Id,DM.Duration_Period_Id,CDD.Batch_Id,CDD.Semester_id,CB.Batch_Code+''-''+CS.Semester_Code as BatchsemesterCode  
  
from Tbl_Candidate_Personal_Det P  
inner join tbl_New_Admission N on P.New_Admission_Id=N.New_Admission_Id  
inner join Tbl_Department D on N.Department_Id=D.Department_Id  
inner join Tbl_Student_Semester SS on p.Candidate_id=SS.Candidate_Id  
inner join Tbl_Course_Duration_Mapping DM on ss.Duration_Mapping_Id=DM.Duration_Mapping_Id  
inner join Tbl_Course_Duration_PeriodDetails CDD on DM.Duration_Period_Id=CDD.Duration_Period_Id  
inner join Tbl_Course_Batch_Duration CB on CDD.Batch_Id=CB.Batch_Id  
inner join Tbl_Course_Semester CS on CDD.Semester_id=CS.Semester_id  
  
where P.Candidate_Id=@Candidateid  
  
end
    ');
END;
