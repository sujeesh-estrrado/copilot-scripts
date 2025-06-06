IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_INSERTFOLLOWUPSTATUS]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_INSERTFOLLOWUPSTATUS]  
(@CandidateId bigint,  
@CurrentStatus varchar(200),  
@EnquiryType varchar(200),  
@NextCallDate datetime,  
@PotentialLevel varchar(200))  
as begin  
  
insert into dbo.Tbl_FollowUp_Status(Candidate_Id,Current_Status,Enquiry_Type,  
Next_Call_Date,Potential_Level) values(@CandidateId,@CurrentStatus,@EnquiryType,  
@NextCallDate,@PotentialLevel)  
  
select scope_identity()  
  
end


    ')
END
