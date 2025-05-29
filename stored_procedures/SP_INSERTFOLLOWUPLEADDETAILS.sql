IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_INSERTFOLLOWUPLEADDETAILS]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_INSERTFOLLOWUPLEADDETAILS]        
(@Counselor varchar(200),        
@CandidateId bigint,        
@FollowupDate datetime,        
@FollowupTime varchar(50),        
@Remarks varchar(200),        
@RespondType varchar(200),        
@ActionToBeTaken varchar(200),        
@ActionTaken bit,  
@NextFollowupDate datetime,        
@Medium varchar(50),
@Duration varchar(50),
@LeadStatus_Id bigint)        
as begin        
    --if not exists (select * from Tbl_FollowUp_Detail where Counselor_Employee=@Counselor and Candidate_Id=@CandidateId and Respond_Type=@RespondType and Action_to_Be_Taken=@ActionToBeTaken)  
   
	DECLARE @LeadStatusName varchar(80)
	SELECT @LeadStatusName = Lead_Status_Name FROM Tbl_Lead_Status_Master WHERE Lead_Status_Id = @LeadStatus_Id

	insert into dbo.Tbl_FollowUpLead_Detail(Counselor_Employee,Candidate_Id,        
	Followup_Date,Followup_time,Remarks,Respond_Type,Action_to_Be_Taken,        
	Action_Taken,Next_Date,Medium,Delete_status,Call_Duration,LeadStatus_Id) 
	values(@Counselor,@CandidateId,@FollowupDate,        
	@FollowupTime,@Remarks,@RespondType,@ActionToBeTaken,@ActionTaken,@NextFollowupDate,@Medium,0,@Duration,@LeadStatus_Id)        
	
	--below query used to update leadstatus of selected lead
	update Tbl_Lead_Personal_Det set LeadStatus_Id=@LeadStatus_Id where Candidate_Id=@CandidateId  
	--------------end---------------
	--select * from   Tbl_FollowUpLead_Detail where Candidate_Id=@CandidateId and (Delete_status=0 or Delete_status is null)  
	--order by Follow_Up_Detail_Id desc   
   select FD.*,LSM.Lead_Status_Name from   Tbl_FollowUp_Detail FD
Left JOIN Tbl_Lead_Status_Master LSM on FD.LeadStatus_Id=LSM.Lead_Status_Id
where FD.Candidate_Id=@CandidateId and (Delete_status=0 or Delete_status is null)
order by Follow_Up_Detail_Id desc 

	IF(@LeadStatusName = ''Rejected'')
	BEGIN
	 EXEC [sp_Reject_Lead] @CandidateId,@status= ''Rejected'',@Activestatus = ''Rejected'',@Flag=0
	END
	ELSE IF(@LeadStatusName = ''Move to Application'')
	BEGIN
		EXEC [sp_CopyTopersonal_FromLead] @Candidate_Id = @CandidateId
	END
   
end')
END
