IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_DeleteFOLLOWUPLeadDETAILS]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_DeleteFOLLOWUPLeadDETAILS] --4,4           
(@FollowupdetailId bigint,            
@CandidateId bigint    
)            
as begin            
delete from dbo.Tbl_FollowUpLead_Detail    
where Follow_Up_Detail_Id = @FollowupdetailId           
       
            
select * from   Tbl_FollowUpLead_Detail where Candidate_Id=@CandidateId order by Follow_Up_Detail_Id desc       
            
end    
    
    ')
END
