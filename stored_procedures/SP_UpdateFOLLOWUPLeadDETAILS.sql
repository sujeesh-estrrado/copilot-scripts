IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_UpdateFOLLOWUPLeadDETAILS]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[SP_UpdateFOLLOWUPLeadDETAILS]            
(@Counselor varchar(200),            
@CandidateId bigint,            
@FollowupDate datetime,            
@FollowupTime varchar(50),            
@Remarks varchar(200),            
@RespondType varchar(200),            
@ActionToBeTaken varchar(200),            
@ActionTaken bit,    
@FollowupdetailId bigint,  
@NextFollowupDate datetime,        
@Medium varchar(50),
@Duration varchar(50),
@leadstatus_id bigint
)            
as begin            
            
update dbo.Tbl_FollowUpLead_Detail set Counselor_Employee=@Counselor,    
Candidate_Id=@CandidateId,            
Followup_Date=@FollowupDate,    
Followup_time=@FollowupTime,    
Remarks=@Remarks,    
Respond_Type=@RespondType,    
Action_to_Be_Taken=@ActionToBeTaken,  
  Action_Taken=@ActionTaken,  
  Medium = @Medium,  
  Next_Date = @NextFollowupDate,
  Call_Duration=@Duration,
  LeadStatus_Id=@leadstatus_id
where Follow_Up_Detail_Id = @FollowupdetailId           
     ----update  lead status to lead list

     update Tbl_Lead_Personal_Det set LeadStatus_Id=@leadstatus_id where Candidate_Id=@CandidateId
     --end----
            
select * from   Tbl_FollowUpLead_Detail where Candidate_Id=@CandidateId order by Follow_Up_Detail_Id desc       
            
end
    ')
END;
