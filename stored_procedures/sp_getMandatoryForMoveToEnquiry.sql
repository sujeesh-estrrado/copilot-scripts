IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_getMandatoryForMoveToEnquiry]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_getMandatoryForMoveToEnquiry](@Candidate_id bigint)
as
begin
select LP.Candidate_Fname,LP.Candidate_Lname,LP.Candidate_Nationality,LP.Residing_Country,LC.Candidate_Email,LP.AdharNumber,LC.Candidate_Mob1,LP.CounselorEmployee_id from Tbl_Lead_Personal_Det LP inner join Tbl_Lead_ContactDetails LC on LC.Candidate_Id=LP.Candidate_Id
where LP.Candidate_Id=@Candidate_id and LP.Candidate_DelStatus=0
end
');
END;