IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_CheckEnglishTestWithCandidateId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_CheckEnglishTestWithCandidateId](@Candidate_id bigint)
as
begin
select * from Tbl_Secondery_Course_Inquery where Candidate_id=@candidate_id and delete_status=0;
end
    ')
END;
