IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetSemesterByCandidateId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_GetSemesterByCandidateId]
@Candidate_Id bigint
AS
BEGIN
	select Duration_Mapping_Id from dbo.Tbl_Student_Semester where Candidate_Id=@Candidate_Id
END
');
END;