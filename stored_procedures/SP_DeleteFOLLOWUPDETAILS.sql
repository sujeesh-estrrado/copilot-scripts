IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_DeleteFOLLOWUPDETAILS]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_DeleteFOLLOWUPDETAILS]        
(@FollowupdetailId bigint,        
@CandidateId bigint
)        
as begin        
delete from dbo.Tbl_FollowUp_Detail
where Follow_Up_Detail_Id = @FollowupdetailId       
   
        
select * from   Tbl_FollowUp_Detail where Candidate_Id=@CandidateId order by Follow_Up_Detail_Id desc   
        
end
    ')
END
