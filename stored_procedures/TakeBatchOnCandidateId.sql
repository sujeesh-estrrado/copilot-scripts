IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[TakeBatchOnCandidateId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[TakeBatchOnCandidateId]
(@candidateId bigint)
as
begin
select Batch_Id from tbl_New_Admission NA 
inner join Tbl_Candidate_Personal_Det CPD on CPD.New_Admission_Id=NA.New_Admission_Id
where CPD.Candidate_Id=@candidateId



end

    ')
END;
GO
