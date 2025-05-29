IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_InstallamentBills]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_InstallamentBills]              
(              
@Flag bigint=0,              
@RefInstallmentId bigint=0              
,@accountcodeid bigint=0              
,@docno varchar(20)=''''              
,@description varchar(255)=''''              
,@studentid bigint=0              
,@totalamountpayable decimal(18,2)=0              
,@totalamountpaid decimal(18,2)=0              
,@outstandingbalance decimal(18,2)=0              
,@billgroupid bigint=0              
,@dateissue datetime=''''              
,@datedue datetime=''''              
,@datecreated datetime=''''              
,@createdby bigint=0              
,@dateupdated datetime=''''              
,@updatedby bigint=0              
,@adjustmentamount decimal(18,2)=0              
,@canadjust bigint=0              
,@billcancel bigint=0              
,@status bigint=0          
,@billid bigint=0          
,@Amt decimal(18,2)=0             
,@TransactionID bigint=0,    
@SemID bigint=0    
)              
as              
begin              
 if(@Flag=1)              
 begin              
  INSERT INTO Tbl_Installment_Bills              
  ([RefInstallmentId]              
  ,[accountcodeid]              
  ,[docno]              
  ,[description]              
  ,[studentid]              
  ,[totalamountpayable]              
  ,[totalamountpaid]              
  ,[outstandingbalance]              
  ,[billgroupid]              
  ,[dateissue]              
  ,[datedue]              
  ,[datecreated]              
  ,[createdby]              
  ,[dateupdated]              
  ,[updatedby]              
  ,[adjustmentamount]              
  ,[canadjust]              
  ,[billcancel]              
  ,[flagledger]              
  ,[status])              
  VALUES              
  (@RefInstallmentId,@accountcodeid,@docno,@description,@studentid,@totalamountpayable,@totalamountpaid,@outstandingbalance,              
  @billgroupid,GETDATE(),@datedue,GETDATE(),@createdby,GETDATE(),@updatedby,0,0,0,''M'',0)              
 end              
 if(@Flag=2)    --Installment paying          
 begin           
  update Tbl_Installment_Bills set          
  totalamountpaid =@totalamountpaid,          
  outstandingbalance = @outstandingbalance          
  where billid = @billid          
          
  insert into Tbl_InstallmentPayLog(InstallmentBillId,Amount,TransactionID,LogDate,[Status])          
  values(@billid,@Amt,@TransactionID,GETDATE(),1)          
          
 end          
 if(@Flag =3)    --Get Actual Inv details by Installment bill id        
 begin          
  select sb.*           
  from  tbl_Installment_Bill_Details IBD          
  join Tbl_Installment_Bills IB on IBD.InstallmentId = IB.RefInstallmentId          
  join student_bill sb on sb.billid = IBD.BillId          
  join tbl_Request_Installment RI on RI.Id = IB.RefInstallmentId          
  where IB.billid = @billid         
  and IB.studentid = @studentid          
  and sb.billcancel=0          
  and RI.Status = 1          
  --and SB.outstandingbalance>0          
 end          
 if(@Flag =4)    --Get InstallmentBill details by Installment bill id        
 begin          
  select *           
  from  Tbl_Installment_Bills        
  where billid = @billid        
  
  update student_bill set canadjust = 0 where billid=@billid  
  update student_transaction set canadjust = 0 where billid=@billid  
  
 end         
         
 if(@flag=5)        
 begin        
  update Tbl_Installment_Bills         
  set totalamountpaid = @totalamountpaid,         
   outstandingbalance = @outstandingbalance,         
   dateupdated = GETDATE()        
  where billid = @billid         
 end      
 if(@flag=6)        
 begin        
  select * from Tbl_Installment_Temp_Bills       
  where RefInstallmentId = @RefInstallmentId    
    and status=0    
 end      
 if(@flag=7)        
 begin        
  select *     
  from  tbl_Request_Installment     
  where StudentID =@studentid    
   and Status=1    
   and SemesterId = @SemID    
 end      
  
  if(@flag=8)        
 begin        
  Select *   
  from student_transaction   
  where studentid = @studentid  
   and semesterno = @SemID  
   and accountcodeid = @accountcodeid  
   and amount = @Amt  
   and transactiontype = 0  
   and billid not in(select billid from tbl_Installment_Bill_Details)  
 end      
   
        
end 
');
END;
