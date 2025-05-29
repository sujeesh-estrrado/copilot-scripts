IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Olympia_GetCandidDetailsById]') 
    AND type = N'P'
)
BEGIN
    EXEC('
create procedure [dbo].[SP_Olympia_GetCandidDetailsById]--128  
(@CandidateId bigint)        
as begin        
        
select concat(Candidate_Fname,'' '',Candidate_Mname,'' '',Candidate_Lname) as CandidateName,CPD.ApplicationStatus,
AdharNumber,Candidate_PermAddress,Candidate_Mob1       
from dbo.Tbl_Candidate_Personal_Det CPD   
left join Tbl_Candidate_ContactDetails CCD on CPD.Candidate_Id=CCD.Candidate_Id   
where CPD.Candidate_Id=@CandidateId        
        
end
    ')
END
