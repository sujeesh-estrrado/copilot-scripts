IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SelectAllEntrolledExambyCandidate]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure [dbo].[SelectAllEntrolledExambyCandidate]  --256
(@Candidate_Id bigint,
@Duration_Mapping_Id bigint)
as 
begin 
select DISTINCT ESC.*,ECC.AssesmentType,ESM.Candidate_Id from Tbl_StudentExamSubjectsChild ESC
inner join  dbo.Tbl_Exam_Code_Child ECC on ECC.Exam_Code_final=ESC.ExamCode
inner join Tbl_StudentExamSubjectMaster ESM on ESM.StudentExamSubjectMasterId=ESC.StudentExamSubjectMasterId
inner join [dbo].[Tbl_Student_Semester] ss on ss.Duration_Mapping_Id=ESM.Duration_Mapping_Id
where ESM.Candidate_Id=@Candidate_Id and [Student_Semester_Current_Status]=1
and esm.Duration_Mapping_Id=@Duration_Mapping_Id
end

--=============================

    ')
END
