IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Student_Invoice]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_Student_Invoice]          
(@flag int = 0,          
@docno varchar(50) ='''',          
@remarks varchar(255) ='''',          
@transactionid bigint=0,          
@studentid bigint = 0,          
@totalamount decimal(18, 2) = 0,          
@dateissued datetime =null,          
@datedue datetime =null,          
@checkdate datetime ='''',          
@printcount bigint=0,          
@flagledger char(10) ='''',          
@createdby bigint ='''',          
@accountcodeid bigint = 0,          
@description varchar(255) ='''',          
@bankName varchar(10)='''',          
@receiptnumber varchar(100)='''',          
@refno varchar(30)='''',          
@totalamountpayable decimal(18, 2) = 0,          
@totalamountpaid decimal(18, 2) = 0,          
@outstandingbalance decimal(18, 2) = 0,          
@adjustmentamount decimal(18, 2) = 0,          
@billgroupid bigint = 0,          
@amount decimal(18, 2) = 0,          
@transactiontype int = 0,          
@cashierid bigint = 0,          
@courseid bigint = 0,          
@semesterno int = 0,          
@intakeid bigint = 0,          
@semesterid bigint = 0,          
@billid bigint = 0,          
@paymentmethod bigint = 0,          
@relatedid bigint = 0,          
@receiptid bigint = 0,          
@canadjust bigint = 1,          
@thirdpartyid bigint = 0,          
@billcancel bigint = 0,          
@adjustedid bigint = 0,          
@DocDate datetime =null,          
          
@id int =0 output           
)          
as          
begin          
 if(@flag=1)-- Insert New student_bill_group          
 begin          
  Insert into student_bill_group(docno,studentid,totalamount,dateissued,          
     datedue,printcount,flagledger,createdby,datecreated)          
     values(@docno,@studentid,@totalamount,@dateissued,          
     @datedue,@printcount,@flagledger,@createdby,GETUTCDATE())          
     SET @id=SCOPE_IDENTITY()          
  select  @id as student_bill_group_id          
 end          
 if(@flag = 2) -- Insert New student_bill           
 begin          
  Insert into student_bill(accountcodeid,docno,[description],studentid,totalamountpayable,          
     totalamountpaid,outstandingbalance,billgroupid,dateissue,datedue,datecreated,createdby,          
     adjustmentamount,canadjust,billcancel,flagledger)          
     Values(@accountcodeid,@docno,@description,@studentid,@totalamountpayable,@totalamountpaid,          
     @outstandingbalance,@billgroupid,@dateissued,@datedue,GETUTCDATE(),@createdby,          
     0,1,0,@flagledger)          
  SET @id=SCOPE_IDENTITY()          
  update student_bill_group set totalamount = (select sum(totalamountpayable)           
    from student_bill           
    where billgroupid = @billgroupid) where billgroupid = @billgroupid          
  select  @id as student_bill_id          
 end          
 if(@flag = 3) -- Insert New student_transaction           
 begin          
  INSERT INTO [dbo].[student_transaction]          
           ([accountcodeid],[docno],[description],[amount],[transactiontype],          
     [paymentmethod],[remarks],[datetimeissued],[dateissued],[cashierid],          
     [studentid],[courseid],[semesterno],[intakeid],[semesterid],          
     [billid],[billgroupid],[refdocno],[refdocdate],[adjustmentamount],          
     [canadjust],[adjustedid],[thirdpartyid],[printcount],[billcancel],          
     [flagledger])          
  VALUES          
           (@accountcodeid,@docno,@description,@amount,@transactiontype,          
     @paymentmethod,@remarks,@dateissued,@dateissued,@cashierid,          
     @studentid,@courseid,@semesterno,@intakeid,@semesterid,          
     @billid,@billgroupid,@refno,@DocDate,@adjustmentamount,          
     @canadjust,@adjustedid,@thirdpartyid,@printcount,@billcancel,          
     @flagledger)          
     SET @id=SCOPE_IDENTITY()          
  select  @id as student_transaction_id          
 end          
          
 if(@flag=4)          
 begin          
  Insert into student_payment (accountcodeid,receiptnumber,          
   [description],amount,paymentmethod,datetimeissued,cashierid,          
   studentid,transactionid,refno,checkdate,billid,dateissued,bankname,remarks,flagledger)          
   values(@accountcodeid,@receiptnumber,@description,@amount,@paymentmethod,          
   @dateissued,@cashierid,@StudentId,@transactionid,@refno,@checkdate,@billId,GETUTCDATE(),@bankName,@remarks,          
   @flagledger)          
 end          
 if(@flag = 5) -- Get pending student_bills  by StudentID and FlagLedger          
 begin         
   
 select * from      
(select billid,outstandingbalance,totalamountpaid,adjustmentamount,''INV'' as Typ,datedue from student_bill           
   where studentid=@studentid and outstandingbalance>0  and billcancel=0 --and (flagledger=@flagledger or @flagledger='')         
   and billid not in( select billid  from  tbl_Installment_Bill_Details IBD                    
       join tbl_Request_Installment RI  on IBD.InstallmentId = RI.Id                    
       where RI.Status<>3      and  outstandingbalance>0              
       and RI.StudentID = @studentid    )      
   )as TBl_New      
   union all      
   (      
   select billid,outstandingbalance,totalamountpaid,adjustmentamount ,''INST''  as Typ   ,datedue    
   from Tbl_Installment_Bills IB       
 join tbl_Request_Installment RI on RI.Id = IB.RefInstallmentId      
 where IB.studentid = @studentid and  outstandingbalance>0 and    
 RI.Status = 1      
   )      
   order by datedue   desc    
  
  -- select billid, accountcodeid,docno,[description],studentid,totalamountpayable,          
  --   totalamountpaid,outstandingbalance,billgroupid,dateissue,datedue,datecreated,createdby,          
  --   adjustmentamount,canadjust,billcancel,flagledger          
  --from student_bill            
  --where          
  --(studentid = @StudentId ) and --(flagledger = @flagledger) and        
        
  --outstandingbalance >0 and billcancel =0         
  --and billid not in ( select billid  from  tbl_Installment_Bill_Details IBD                      
  --     join tbl_Request_Installment RI  on IBD.InstallmentId = RI.Id                      
  --     where RI.Status<>3                      
  --     and RI.StudentID = @StudentId   )        
        
  --order by datedue asc              
 end          
 if(@flag=6)          
 begin          
  Update [dbo].[Tbl_Candidate_Personal_Det] set billoutstanding=@amount          
  where Candidate_Id=@studentid          
 end          
 if(@flag=7)          
 begin          
  select  Candidate_Fname + '' '' + Candidate_Mname + '' '' + Candidate_Lname AS StudentName           
  from [dbo].[Tbl_Candidate_Personal_Det]          
  where Candidate_Id=@studentid          
 end          
 if(@flag=8)--Get Transaction details of Invoice          
 begin          
SELECT        ST.transactionid, ST.accountcodeid, ST.docno, ST.description, ST.amount, ST.balance, ST.paymentmethod, SB.totalamountpayable, SB.totalamountpaid, ST.billid,           
                         ST.studentid, ST.flagledger, ST.transactiontype, ST.billgroupid, SBG.docno AS BillGroupDocNo, SB.outstandingbalance, SB.adjustmentamount,           
                         ST.adjustmentamount AS transaAdjstAmt, ST.dateissued as dateissue          
FROM            dbo.student_transaction AS ST LEFT OUTER JOIN          
                         dbo.student_bill AS SB ON ST.billid = SB.billid LEFT OUTER JOIN          
                         dbo.student_bill_group AS SBG ON SB.billgroupid = SBG.billgroupid          
  WHERE        (ST.transactionid = @transactionid)          
 end          
          
 if(@flag=9)--All_DebitAmount_List---          
 begin          
  --SELECT  docno,receiptid,p.accountcodeid,p.[description] ,(p.amount-p.adjustmentamount)as amount,p.billid          
  --from student_transaction t           
  --left join student_payment p on t.transactionid=p.transactionid          
  if(@transactiontype=1)          
   begin          
    select  t.docno,receiptid,p.accountcodeid,p.[description] ,COALESCE((p.amount-p.adjustmentamount),0)as amount,p.billid,COALESCE(p.amount,0) as totalamount,          
     a.name+''-''+p.[description] as Item1,          
    CASE WHEN a.name+''-''+p.[description]=a.name+''-''+p.[description] THEN a.name+''-''+p.[description]          
     WHEN a.name+''-''+p.[description]='''' THEN ''Open Payment'' WHEN a.name+''-''+p.[description]=NULL THEN ''Open Payment'' END as Item2,          
     CASE WHEN P.accountcodeid!=0 THEN a.name+''-''+p.[description]          
     WHEN P.accountcodeid=0 THEN ''Open Payment'' WHEN P.accountcodeid=NULL THEN ''Open Payment'' END as Item,          
      a.name,COALESCE(outstandingbalance,0)as outstandingbalance,COALESCE(totalamountpaid,0)as totalamountpaid,COALESCE(totalamountpayable,0)as totalamountpayable,COALESCE(p.adjustmentamount,0)as adjustmentamount,t.canadjust          
      ,b.flagledger          
    from student_transaction t           
    left join student_payment p  on t.transactionid=p.transactionid          
    left join ref_accountcode a on p.accountcodeid=a.id          
    left join student_bill b on b.billid=p.billid          
    where t.transactionid=@transactionid and p.canadjust=1          
   end          
  else          
   begin          
    select  t.docno,receiptid,p.accountcodeid,p.[description] ,COALESCE((t.amount-t.adjustmentamount),0)as amount,p.billid,COALESCE(t.amount,0) as totalamount,          
     t.[description] as Item, a.name,outstandingbalance,totalamountpaid,totalamountpayable, p.[description],t.adjustmentamount,          
      CASE WHEN P.accountcodeid!=0 THEN t.[description]          
     WHEN P.accountcodeid=0 THEN ''Open Payment'' WHEN P.accountcodeid=NULL THEN ''Open Payment'' END as Item1          
    from student_transaction t           
    left join student_payment  p on t.transactionid=p.transactionid          
    left join ref_accountcode a on p.accountcodeid=a.id          
    left join student_bill b on b.billid=p.billid          
    where t.transactionid=@transactionid and t.canadjust=1          
   end          
 end              
           
 if(@flag=10)--All_DebitAmount_List---          
  begin          
            
   update student_transaction set adjustmentamount=@adjustmentamount,relatedid=@relatedid,canadjust=@canadjust          
   where transactionid=@transactionid          
          
  end               
 if(@flag=11)--All_DebitAmount_List---          
  begin          
            
   update student_bill set totalamountpaid=@totalamountpaid,outstandingbalance=@outstandingbalance,canadjust=1          
   where billid=@billid          
              
  end              
  if(@flag=12)--All_DebitAmount_List---          
   begin          
    update student_payment set adjustmentamount=@adjustmentamount,canadjust=@canadjust          
   where receiptid=@receiptid          
   end           
   if(@flag=13)--Update transation when Cancel Bill/Invoice          
  begin          
            
   update student_transaction set billcancel=1,canadjust=1,relatedid=@relatedid,adjustmentamount= adjustmentamount+@adjustmentamount          
   where transactionid=@transactionid          
          
  end              
  if(@flag=14)--All_DebitAmount_List---          
  begin          
            
   update student_bill set billcancel =1, totalamountpaid=0,outstandingbalance=0,adjustmentamount = totalamountpayable          
   where billid=@billid          
              
  end               
  if(@flag=15)          
  begin          
            
   update student_transaction set relatedid=@relatedid,canadjust=@canadjust,adjustmentamount = @adjustmentamount          
   where transactionid=@transactionid          
              
  end             
  if(@flag=16) --Update Bill totalamountpaid+outstandingbalance+canadjust          
  begin          
   update student_bill set totalamountpaid=@totalamountpaid,outstandingbalance=@outstandingbalance,canadjust=@canadjust,adjustmentamount = @adjustmentamount          
   where billid=@billid          
  end               
  if(@flag=17)          
  begin          
   update student_transaction set relatedid=@relatedid,canadjust=@canadjust, billcancel= @billcancel, adjustmentamount = @adjustmentamount          
   where transactionid=@transactionid          
  end            
  if(@flag=18)          
  begin          
   select * from student_transaction where [description]=''REF No : ''+@description          
  end            
          
  if(@flag=19)--get Bill details by BillId          
  begin          
   select billid, accountcodeid,docno,[description],studentid,totalamountpayable,          
     totalamountpaid,outstandingbalance,billgroupid,dateissue,datedue,datecreated,createdby,          
     adjustmentamount,canadjust,billcancel,flagledger          
   from student_bill            
   where billid = @billid          
  end           
  if(@flag=20)--get Transaction details by TransactionID          
  begin          
   select * from student_transaction where transactionid = @transactionid          
  end           
  if(@flag=21)--get Paid transaction by StudentID, Ledger, DESC Ordr          
  begin          
  select * from      
(select billid,outstandingbalance,totalamountpaid,adjustmentamount,''INV'' as Typ,datedue from student_bill           
   where studentid=@studentid and totalamountpaid>0  and billcancel=0 --and (flagledger=@flagledger or @flagledger='')         
   and billid not in( select billid  from  tbl_Installment_Bill_Details IBD                    
       join tbl_Request_Installment RI  on IBD.InstallmentId = RI.Id                    
       where RI.Status<>3      and  totalamountpaid>0              
       and RI.StudentID = @studentid    )      
   )as TBl_New      
   union all      
   (      
   select billid,outstandingbalance,totalamountpaid,adjustmentamount ,''INST'' as Typ   ,datedue   
   from Tbl_Installment_Bills IB       
 join tbl_Request_Installment RI on RI.Id = IB.RefInstallmentId      
 where IB.studentid = @studentid and  totalamountpaid>0 and    
 RI.Status = 1      
   )      
   order by datedue   asc    
  end           
          
  if(@flag=22)--get Paid transaction by StudentID, Ledger, DESC Ordr          
  begin          
   SELECT [receiptid]          
     ,[receiptnumber]          
     ,[accountcodeid]          
     ,[description]          
     ,[amount]          
     ,[payment]          
     ,[balance]          
     ,[paymentmethod]          
     ,[remarks]          
     ,[datetimeissued]          
     ,[cashierid]          
     ,[studentid]          
     ,[transactionid]          
     ,[billid]          
     ,[dateissued]          
     ,[bankname]          
     ,[refno]          
     ,[checkdate]          
     ,[adjustmentamount]          
     ,[canadjust]          
     ,[flagledger]          
     ,(amount-adjustmentamount) as adjustableAmount          
   FROM [dbo].[student_payment]          
   where           
     canadjust=1            
    and (amount-adjustmentamount)>0           
    and studentid=@studentid           
   order by receiptid desc          
  end           
            
end 

');
END;
