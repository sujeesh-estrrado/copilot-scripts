IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Delete_Candidate_WorkExperience_Details_By_CandidateID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[sp_Delete_Candidate_WorkExperience_Details_By_CandidateID]
(
@Candidate_Id bigint =0
)
as
begin
    update Tbl_Candidate_WorkExperience set Delete_Status =1 where Candidate_Id=@Candidate_Id
end
    ')
END
