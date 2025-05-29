IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetRefundableAmount]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetRefundableAmount] --59813            
(@StudentID bigint =0              
)              
as              
begin    
  
  
        
  select  (select ISNULL(sum(floatamount),0) as TotalFloat from student_payment_float              
    where  studentid=@StudentID and floatamount >0)+(select ISNULL(sum(totalamountpaid-adjustmentamount),0) as TotalPaid from student_bill               
   where studentid=@StudentID and billcancel =0) as MaxRefundAmt              
            
       
    
end
');
END;