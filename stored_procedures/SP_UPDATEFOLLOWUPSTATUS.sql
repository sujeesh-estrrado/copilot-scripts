IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_UPDATEFOLLOWUPSTATUS]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_UPDATEFOLLOWUPSTATUS] 
(@CandidateId bigint,
@CurrentStatus varchar(200),
@EnquiryType varchar(200),
@NextCallDate datetime,
@PotentialLevel varchar(200))

AS BEGIN

UPDATE dbo.Tbl_FollowUp_Status set 
Current_Status=@CurrentStatus,
Enquiry_Type=@EnquiryType,
Next_Call_Date=@NextCallDate,
Potential_Level=@PotentialLevel
where Candidate_Id=@CandidateId

END
   ')
END;
