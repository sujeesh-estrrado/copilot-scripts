IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_TERM_FROMID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GET_TERM_FROMID] --136

(@Candidate_Id bigint)

AS BEGIN

select DISTINCT SEM.Candidate_Id,SEC.Term FROM dbo.Tbl_StudentExamSubjectsChild SEC 
INNER JOIN dbo.Tbl_StudentExamSubjectMaster SEM ON 
SEC.StudentExamSubjectMasterId=SEM.StudentExamSubjectMasterId
WHERE SEM.Candidate_Id=@Candidate_Id

END

    ')
END;
