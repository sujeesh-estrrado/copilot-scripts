-- Create GET_TABLE_DET procedure if it does not exist
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[GET_TABLE_DET]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       
CREATE procedure [dbo].[GET_TABLE_DET] 
@Subject_Id BIGINT,
@Exam_Term VARCHAR(200)

AS
BEGIN
 
          
select distinct A.[Candidate_Id],A.[Name],A.[IC_Passport],A.ExamCode,A.Actual_Marks AS Marks,B.AssesmentType,D.Department_Id,CBD.Batch_Id,s.Subject_Name,s.Subject_Id                
from Tbl_Exam_Mark_Entry_Child A                            
inner join Tbl_Exam_Code_Child B on B.Exam_Code_final=A.ExamCode                  
INNER JOIN dbo.Tbl_Candidate_Personal_Det CPD ON CPD.AdharNumber=A.IC_Passport                  
inner join dbo.Tbl_StudentExamSubjectMaster SEM ON CPD.Candidate_Id=SEM.Candidate_Id                          
INNER JOIN dbo.Tbl_StudentExamSubjectsChild SEC ON SEM.StudentExamSubjectMasterId=SEC.StudentExamSubjectMasterId  
AND A.ExamCode=SEC.ExamCode                          
INNER JOIN dbo.Tbl_Department D ON D.Department_Id =SEM.Department_Id                          
INNER JOIN dbo.Tbl_Course_Duration_Mapping CDM ON CDM.Duration_Mapping_Id=SEM.Duration_Mapping_Id                          
INNER JOIN dbo.Tbl_Course_Duration_PeriodDetails CDP ON CDP.Duration_Period_Id=CDM.Duration_Period_Id                          
INNER JOIN dbo.Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id=CDP.Batch_Id                          
INNER JOIN dbo.Tbl_Course_Semester CS ON CS.Semester_Id=CDP.Semester_Id                          
INNER JOIN dbo.Tbl_Exam_Code_Child ECC ON ECC.Exam_Code_final=SEC.ExamCode                          
INNER JOIN dbo.Tbl_Exam_Code_Master ECM ON ECM.Exam_Code_Master_Id=ECC.Exam_Code_Master_Id                          
INNER JOIN dbo.Tbl_GroupChangeExamDates GC ON GC.ExamCode=ECC.Exam_Code_final                          
inner join Tbl_Department_Subjects DS ON DS.Course_Department_Id=D.Department_Id                
inner join  tbl_Subject s on s.Subject_Id=SEC.SubjectId            
where    S.Subject_Id=@Subject_Id and ECM.Exam_Term=@Exam_Term
END
    ')
END;
GO
