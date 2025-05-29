IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Candidate_List_By_AgentID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Candidate_List_By_AgentID] --1
(
@Agent_ID bigint
)          
AS            
BEGIN 
select Candidate_Id,Upper(Candidate_Fname)+'' ''+Upper(Candidate_Lname) as Candidate_Name,Agent_ID,ApplicationStatus from Tbl_Candidate_Personal_Det D
 where Agent_ID=@Agent_ID and (ApplicationStatus=''pending'' or ApplicationStatus=''submited'' or ApplicationStatus=''approved''or ApplicationStatus=''rejected''
 or ApplicationStatus=''Verified''  or ApplicationStatus=''Conditional_Admission''  or ApplicationStatus=''Preactivated'')
end

    ')
END;
