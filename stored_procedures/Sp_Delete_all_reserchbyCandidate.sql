IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Delete_all_reserchbyCandidate]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Delete_all_reserchbyCandidate](@candidateid bigint=0)
as
begin
update Tbl_Candidate_research set Delete_Status=1 where Candidate_Id=@candidateid;
end

--select * from Tbl_Candidate_research
    ')
END
