IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[UpdatePaidStatus_fine]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[UpdatePaidStatus_fine]    
    
(@CandidateId bigint,  
@ItemDesc varchar(100),                  
@FeeHead bigint)    
    
as begin    
    
update Tbl_Fine_Approval set PaidStatus=1   
where Candidate_Id=@CandidateId and ItemDesc=@ItemDesc   
and FeeHeadId =@FeeHead   
end    


   ')
END;
