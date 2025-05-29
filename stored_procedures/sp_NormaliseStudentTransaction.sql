IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_NormaliseStudentTransaction]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[sp_NormaliseStudentTransaction]      
(      
@flag bigint =0   ,      
@totalamountpaid decimal(18,2) = 0,      
@outstandingbalance decimal(18,2) = 0,      
@billid bigint = 0  ,      
@studentid bigint = 0      
)      
as      
begin      
 if(@flag=9898)    
 begin    
 update Tbl_Candidate_Personal_Det set InvDue=0
	
  UPDATE J    
  SET J.InvDue = A.TotalOuts    
  FROM Tbl_Candidate_Personal_Det J    
  INNER JOIN (    
   SELECT cpd.Candidate_Id,cpd.InvDue    
    , SUM(outstandingbalance) as TotalOuts    
   from Tbl_Candidate_Personal_Det cpd    
  join student_bill  st on st.studentid = cpd.Candidate_Id    
  where st.billcancel=0    
  group by cpd.Candidate_Id,cpd.InvDue    
  --group by cpd.Candidate_Id    
   ) A ON J.Candidate_Id = A.Candidate_Id    
 end     
 if(@flag=1)      
 begin      
  select distinct studentid from student_transaction where billcancel=0      
 end      
 if(@flag=2)      
 begin      
  select Candidate_Id,InvDue,billoutstanding, (InvDue-billoutstanding)as NewFloat      
  from Tbl_Candidate_Personal_Det where InvDue >0 and (InvDue>billoutstanding)      
 end      
 if(@flag=3)      
 begin      
  select Candidate_Id,InvDue,billoutstanding, (InvDue-billoutstanding)as NewFloat      
  from Tbl_Candidate_Personal_Det where InvDue >0 and (InvDue>billoutstanding)      
 end      
 if(@flag=4)   --Bill with minus outstanding      
 begin      
  select studentid,((totalamountpaid-totalamountpayable)+outstandingbalance) as AmtDiff,(totalamountpaid-totalamountpayable)as amt2Pay,outstandingbalance,*      
  from student_bill where billcancel=0 and outstandingbalance<0 --and ((totalamountpaid-totalamountpayable)+outstandingbalance)=0      
 end      
 if(@flag=5)   --Update Bill with minus outstanding      
 begin      
  update student_bill set totalamountpaid = @totalamountpaid, outstandingbalance = @outstandingbalance where billid = @billid      
 end      
 if(@flag=6)   --Students Outstanding -neg outstanding bal      
 begin      
    select billoutstanding,Candidate_Id,*      
    from Tbl_Candidate_Personal_Det      
    where Candidate_Id in ( select distinct studentid from student_transaction where billcancel=0 )      
      and billoutstanding <0      
 end      
 if(@flag=7)   --Students with -neg outstanding bills      
 begin      
    select InvDue,billoutstanding,(billoutstanding-InvDue) as AdjAmt,* from Tbl_Candidate_Personal_Det      
     where InvDue<billoutstanding and billoutstanding>0      
     and ((InvDue-billoutstanding)>1 or (billoutstanding-InvDue)>1)      
 end      
 if(@flag=8)   --Get Adjustable Bills by StudentID      
 begin      
    select (totalamountpaid-adjustmentamount) as Adjustable,totalamountpaid,outstandingbalance,billid,*      
    from student_bill      
    where billcancel<>1 and     
    studentid=@studentid  and (totalamountpaid-adjustmentamount) >0      
    order by student_bill.billid desc      
 end      
 if(@flag=9)   --Total Actual paid amount Group by Student      
 begin      
    select studentid,SUM(amount) as Amt, CONVERT(decimal(18,2), sum(adjustmentamount)) as AdjAmt,      
      CONVERT(decimal(18,2), (SUM(amount)-sum(adjustmentamount))) as ActualPaid      
     from student_transaction      
    where (transactiontype = 1 ) and billcancel=0      
    --and studentid= 58399      
    group by studentid      
 end      
 if(@flag=10)   --Get Adjustable Bills by StudentID      
 begin      
  select * from student_bill where studentid = @studentid and billcancel=0      
 end      
 if(@flag=11)      
 begin      
  select COALESCE( (select SUM(amount) as Amt--, CONVERT(decimal(18,2), sum(adjustmentamount)) as AdjAmt,      
      --CONVERT(decimal(18,2), (SUM(amount)-sum(adjustmentamount))) as ActualPaid      
     from student_transaction      
    where (transactiontype = 1 or transactiontype=5) and billcancel=0      
    and studentid= @studentid)      
    -      
   (select COALESCE(SUM(amount),0) as Amt--, CONVERT(decimal(18,2), sum(adjustmentamount)) as AdjAmt,      
      --CONVERT(decimal(18,2), (SUM(amount)-sum(adjustmentamount))) as ActualPaid      
     from student_transaction      
    where (transactiontype = 2 or transactiontype=4) and billcancel=0      
  and studentid= @studentid),0) as ActualPayAmt      
 end      
 if(@flag=12)   --Correct FinanceIssueProfiles With Outstanding =0    
 begin      
  update student_bill set outstandingbalance=0, totalamountpaid=totalamountpayable    
  where studentid in (    
   select Candidate_Id as StudID-- InvDue,billoutstanding,(InvDue-billoutstanding) as Diff, *     
   from Tbl_Candidate_Personal_Det    
   where InvDue<>billoutstanding    
   and (billoutstanding=0)    
  )    
 end     
 if(@flag=13)   --Get FinanceIssueProfiles With Outstanding <0    
 begin      
  select InvDue,billoutstanding,(InvDue-billoutstanding) as Diff, *     
  from Tbl_Candidate_Personal_Det    
  where InvDue<>billoutstanding    
   and (billoutstanding<0)    
 end     
 if(@flag=14)   --Get FinanceIssueProfiles With InvDue>billoutstanding    
 begin      
  select InvDue,billoutstanding,(InvDue-billoutstanding) as Diff, *     
  from Tbl_Candidate_Personal_Det    
  where InvDue<>billoutstanding    
   and (billoutstanding>0)    
   and InvDue>billoutstanding    
 end     
 if(@flag=15)   --Get FinanceIssueProfiles With InvDue<billoutstanding    
 begin      
  select InvDue,billoutstanding,(billoutstanding-InvDue) as Diff, *     
  from Tbl_Candidate_Personal_Det    
  where  InvDue<billoutstanding    
   and InvDue>0  
 end     
 if(@flag=16)   --Pay All bills by studentid    
 begin      
  update student_bill set outstandingbalance=0, totalamountpaid=totalamountpayable    
  where studentid = @studentid    
 end   
 if(@flag=17)   --Issue candidates    
 begin        
 select InvDue,billoutstanding,(InvDue-billoutstanding) as Diff, *     
from Tbl_Candidate_Personal_Det    
where InvDue<>billoutstanding    
and not (InvDue=0 and(billoutstanding=0 or billoutstanding<0))    
 end    

  if(@flag=18)   --Reset Invoice Payments
 begin        
	update student_bill set totalamountpaid=0, outstandingbalance=totalamountpayable
	update student_bill set totalamountpaid=adjustmentamount, outstandingbalance=totalamountpayable-adjustmentamount where adjustmentamount>0
 end    
  if(@flag=19)   --Total Actual paid amount Group by Student   by GroupPayment     
 begin        
    select studentid,SUM(amount) as Amt, CONVERT(decimal(18,2), sum(adjustmentamount)) as AdjAmt,        
      CONVERT(decimal(18,2), (SUM(amount)-sum(adjustmentamount))) as ActualPaid        
     from student_transaction        
    where (transactiontype = 5 ) and billcancel=0        
    --and studentid= 58399        
    group by studentid        
 end  
    
end      ');
END;
