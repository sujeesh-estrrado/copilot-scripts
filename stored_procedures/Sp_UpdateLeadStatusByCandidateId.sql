IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_UpdateLeadStatusByCandidateId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
            CREATE PROCEDURE [dbo].[Sp_UpdateLeadStatusByCandidateId]
@LeadStatusId bigint,
@CandidateId bigint
as
begin
update Tbl_Lead_Personal_Det set LeadStatus_Id=@LeadStatusId where Candidate_Id=@CandidateId
DECLARE @LeadStatusName varchar(80)
SELECT @LeadStatusName = Lead_Status_Name FROM Tbl_Lead_Status_Master WHERE Lead_Status_Id = @LeadStatusId
IF(@LeadStatusName = ''Rejected'')
BEGIN
update Tbl_Lead_Personal_Det set ApplicationStatus = ''rejected'' WHERE Candidate_Id=@CandidateId

 EXEC [sp_Reject_Lead] @CandidateId,@status= ''Rejected'',@Activestatus = ''Rejected'',@Flag=0
END
ELSE IF(@LeadStatusName = ''Move to Application'')
BEGIN
	EXEC [sp_CopyTopersonal_FromLead] @Candidate_Id = @CandidateId
END
end

');
END;
