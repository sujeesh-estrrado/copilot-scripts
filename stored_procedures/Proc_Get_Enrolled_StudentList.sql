IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_Enrolled_StudentList]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       
CREATE procedure [dbo].[Proc_Get_Enrolled_StudentList]  
as  
begin  
    
   
SELECT distinct ECM.Campus,D.Course_Code,D.Department_Name, CPD.AdharNumber as IC,CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname as NAME,         
ECM.Exam_Term as ExamTerm,ECC.Exam_Code_final,CONVERT(VARCHAR(50),ECM.ExamDate,103) AS ExamDate,          
GC.ExamDescription,GC.Venue,DATENAME(weekday,ECM.ExamDate) as ExamDay,          
CONVERT(VARCHAR(5),[From],108)+''-''+ CONVERT(VARCHAR(5),[to],108) as Exam_Duration,    
CONVERT(VARCHAR(5),[From],108)+''-''+CONVERT(VARCHAR(5),[To],108)  as time_exam,    
case OpenStatus      
when ''0'' then ''Closed''          
else ''Open''        
end as OpenStatus,CBD.Batch_Code+''-''+ CS.Semester_Code as BatchSemester,Subject_Name          
          
FROM dbo.Tbl_StudentExamSubjectMaster SEM     
       
INNER JOIN dbo.Tbl_StudentExamSubjectsChild SEC ON SEM.StudentExamSubjectMasterId=SEC.StudentExamSubjectMasterId          
INNER JOIN dbo.Tbl_Department D ON D.Department_Id =SEM.Department_Id          
INNER JOIN dbo.Tbl_Course_Duration_Mapping CDM ON CDM.Duration_Mapping_Id=SEM.Duration_Mapping_Id          
INNER JOIN dbo.Tbl_Course_Duration_PeriodDetails CDP ON CDP.Duration_Period_Id=CDM.Duration_Period_Id          
INNER JOIN dbo.Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id=CDP.Batch_Id          
INNER JOIN dbo.Tbl_Course_Semester CS ON CS.Semester_Id=CDP.Semester_Id          
INNER JOIN dbo.Tbl_Exam_Code_Child ECC ON ECC.Exam_Code_final=SEC.ExamCode          
INNER JOIN dbo.Tbl_Exam_Code_Master ECM ON ECM.Exam_Code_Master_Id=ECC.Exam_Code_Master_Id          
INNER JOIN dbo.Tbl_GroupChangeExamDates GC ON GC.ExamCode=ECC.Exam_Code_final     
inner JOIN Tbl_Department_Subjects DS ON DS.Subject_Id=SEC.SubjectId         
inner JOIN Tbl_Semester_Subjects SD ON SD.Department_SubjectS_Id=DS.Department_Subject_Id         
inner JOIN Tbl_Subject S ON s.Subject_Id=SEC.SubjectId              
  inner join Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=SEm.Candidate_Id   
  
    
end 
    ')
END
