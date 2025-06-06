IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Lead_ContactDet]') 
    AND type = N'P'
)
BEGIN
    EXEC('
     CREATE procedure [dbo].[SP_Update_Lead_ContactDet](@PermanentAddress varchar(max),@Email varchar(200),@candidate_id bigint,
@Mobile varchar(100),@CandidatePermAddress_Line2 varchar(max),@CandidatePermAddress_postCode varchar(max),
@CandidatePermAddress_Country bigint,@CandidatePermAddress_State bigint,@CandidatePermAddress_City bigint)
                        as
                        begin



                        update Tbl_Lead_ContactDetails set Candidate_PermAddress=@PermanentAddress,
                        Candidate_Email=@Email,Candidate_Mob1=@Mobile,Candidate_PermAddress_Line2=@CandidatePermAddress_Line2,
                        Candidate_PermAddress_postCode=@CandidatePermAddress_postCode,Candidate_PermAddress_Country=@CandidatePermAddress_Country,
                        Candidate_PermAddress_State=@CandidatePermAddress_State,Candidate_PermAddress_City=@CandidatePermAddress_City where Candidate_Id=@candidate_id

                        end
    ')
END;
