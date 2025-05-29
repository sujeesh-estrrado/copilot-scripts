IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_FINALSTATUS_Refund_APPROVAL]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GET_FINALSTATUS_Refund_APPROVAL] --105,''PTPN -installment-5'',4             
              
(@CandidateId BIGINT,@ItemDesc VARCHAR(100),@FeeHead BIGINT)              
              
AS BEGIN              
              
select DA.FinalStatus,DA.RefundAmount,      
DA.YesNoStatus,DA.Refund_Approval_Id,AH.Priority,AH.AuthorityUserId from dbo.Tbl_Refund_Approval DA            
  inner join dbo.Tbl_Approval_Hierarchy AH on AH.AuthorityUserId=DA.AuthorityUserId            
where Candidate_Id=@CandidateId AND ItemDesc=@ItemDesc AND FeeHeadId=@FeeHead        
--and PaidStatus is null          
            
order by AH.Priority             
              
END 

   ')
END;
