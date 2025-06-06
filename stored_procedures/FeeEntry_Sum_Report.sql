IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[FeeEntry_Sum_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[FeeEntry_Sum_Report]        --327,11829--157,11830--265,11850                    
( @CandidateId bigint,@intake bigint  )                           
as                              
begin 
  select  Candidate_Id,IntakeId,sum(Amount) as Payable,sum(Paid) Paid,sum(Balance) Balance from  dbo.Tbl_Fee_Entry_Main where Candidate_Id=@CandidateId and IntakeId=@intake group by  Candidate_Id,IntakeId



end

    ')
END
ELSE
BEGIN
EXEC('
ALTER procedure [dbo].[FeeEntry_Sum_Report]                   
( @CandidateId bigint,@intake bigint  )                           
as                              
begin 
  select  Candidate_Id,IntakeId,sum(Amount) as Payable,sum(Paid) Paid,sum(Balance) Balance from  dbo.Tbl_Fee_Entry_Main where Candidate_Id=@CandidateId and IntakeId=@intake group by  Candidate_Id,IntakeId



end



')
END
