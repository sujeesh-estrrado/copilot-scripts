IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_CandidateSubmitStatus]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Update_CandidateSubmitStatus]    -- 1008, ''Candidate_Second ''             
(@Candidate_Id bigint,
 @ApplicationStatus varchar(Max)
 )                    
AS                    
BEGIN                    
UPDATE Tbl_Candidate_Personal_Det                    
SET
ApplicationStatus=@ApplicationStatus where Candidate_Id=@Candidate_Id
end
    ')
END;
