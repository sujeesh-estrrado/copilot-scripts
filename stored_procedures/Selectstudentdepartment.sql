IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Selectstudentdepartment]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Selectstudentdepartment]
(@CandidateId bigint)
as
begin
select Department_Id,Candidate_Fname+'' ''+Candidate_Mname+'' ''+Candidate_Lname CandidateName from dbo.Tbl_Student_Registration SR
inner join Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=SR.Candidate_Id

 where SR.Candidate_Id=@CandidateId
end
    ')
END;
