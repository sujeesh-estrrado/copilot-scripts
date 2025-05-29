IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_FINALSTATUS_DISC_APPROVAL]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GET_FINALSTATUS_DISC_APPROVAL]    
    
(@CandidateId BIGINT,@ItemDesc VARCHAR(100),@FeeHead BIGINT)    
    
AS BEGIN    
    
select DA.FinalStatus,DA.DiscountAmount,AH.Priority,AH.AuthorityUserId from dbo.Tbl_Discount_Approval DA  
  inner join dbo.Tbl_Approval_Hierarchy AH on AH.AuthorityUserId=DA.AuthorityUserId  
where Candidate_Id=@CandidateId AND ItemDesc=@ItemDesc AND FeeHeadId=@FeeHead  
  
order by AH.Priority   
    
END

   ')
END;
