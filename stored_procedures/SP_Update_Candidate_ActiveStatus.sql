IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Candidate_ActiveStatus]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Update_Candidate_ActiveStatus]-- 1,100,'''''''',''''--select--'''',''''--select--'''',''''--select--'''',''''28/12/2015'''',''''28/12/2015''''        
(            
                       
@ActiveStatus varchar(100),        
@CandidateId bigint
)                                                    
AS                                                  
BEGIN  
update Tbl_Candidate_Personal_Det set Active_Status=@ActiveStatus
where   Candidate_Id =  @CandidateId 
select @CandidateId
   End
    ')
END
