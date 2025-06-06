IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_LEADAssign_UpdateIsPrev]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure   [dbo].[SP_Tbl_LEADAssign_UpdateIsPrev]    
(    
    @CandidateId bigint
)    
AS
BEGIN

Update Tbl_LeadAssign Set isPrev=0 Where Candidate_Id=@CandidateId
Update Tbl_LeadAssign Set isPrev=1 Where Candidate_Id=@CandidateId
    and leadAssignID=
        (Select cast(right(max(convert(varchar(19),startDtim,120)+right(''0000000000''+cast(leadAssignID as varchar(10)),10)),10) as bigint) ID
        From Tbl_LeadAssign
        Where Candidate_Id=@CandidateId
            and isLatest=0)

END
    ')
END
