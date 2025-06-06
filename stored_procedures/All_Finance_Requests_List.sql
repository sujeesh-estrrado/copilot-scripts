IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[All_Finance_Requests_List]') 
    AND type = N'P'
)
BEGIN
    EXEC(' 
        CREATE procedure [dbo].[All_Finance_Requests_List]-- 1,0,1,0,'''','''',0,0,1,0  
     --[dbo].[All_Finance_Requests_List] 1,0,1,0,'''','''',  
    @flag int  
    ,@RequestId bigint =0  
    ,@ApprovalStatus bigint =0  
    ,@ApprovalBy bigint =0  
    ,@ApprovalDate Datetime=''''  
    ,@ApprovalRemark varchar(500)=''''  
    ,@amount decimal(18,0)=0  
 ,@transactiontype bigint =0  
 ,@roleid bigint=0  
 ,@RefundStatus bigint=0  
AS  
BEGIN  
     
if(@flag=1)----Select ApprovalRequests------  
        begin  
            Select distinct StudentId,RequestTypeId,ApprovalStatus , RequestId,T.[Types],R.ApprovalBy,D.Department_Name,  
   (case when C.Adharnumber='''' then ''-NA-'' when C.Adharnumber is null then ''-NA-'' else C.Adharnumber end)as Adharnumber,  
   (case when C.IDMatrixNo='''' then ''-NA-'' when C.IDMatrixNo is null then ''-NA-'' else C.IDMatrixNo end)as MetrixNo,  
   (case when cbd.Batch_Code='''' then ''-NA-'' when cbd.Batch_Code is null then ''-NA-'' else cbd.Batch_Code end)as Batch,  
            Candidate_Fname + '' ''+ Candidate_Lname AS StudentName ,  
               CASE WHEN ApprovalStatus = 1 and R.RefundStatus is null THEN ''Pending''  
                     WHEN ApprovalStatus = 2 and R.RefundStatus is null THEN ''Approved''  
      WHEN ApprovalStatus = 2 and R.RefundStatus=0 THEN ''Approved''  
      WHEN ApprovalStatus = 1 and R.RefundStatus=0 THEN ''Pending''  
                     WHEN ApprovalStatus = 3 THEN ''Rejected''  
      WHEN ApprovalStatus = 2 and R.RefundStatus=3 THEN ''Paid''  
      WHEN ApprovalStatus = 1 and R.RefundStatus=1 THEN ''Pending(Approved)''  
                     WHEN ApprovalStatus = 1 and R.RefundStatus=2 THEN ''Pending(Processing)''  
                    END AS StatusApproval,CONVERT(varchar, R.RequestDate,103)as RequestDate  
                    ,CONVERT(varchar,R.ApprovalDate,103) as ApprovalDate  
            from Approval_Request R  
            Left join Approval_Request_Type T on T.Id=R.RequestTypeId  
            left join Tbl_Candidate_Personal_Det C on C.Candidate_Id=R.StudentId  
   left join Tbl_New_Admission NA on NA.New_Admission_Id=C.New_Admission_Id  
         left join Tbl_Department D on D.Department_Id= NA.Department_Id   
   left join dbo.Tbl_Student_Semester SS on SS.Candidate_Id=C.Candidate_Id   and  SS.Student_Semester_Delete_Status=0 and   ss.student_semester_current_status=1                                
   left JOIN Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                                     
   left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id  
            where T.[Types] != ''OnlinePayment'' and (RequestTypeId = @transactiontype or @transactiontype = 0 )  
   and (ApprovalStatus = @ApprovalStatus or @ApprovalStatus = 0 )  
   and RequestTypeId in (select distinct AR.Id from Approval_Request_Type AR  
 left join tbl_FinanceAccessMaster FM on AR.Id=FM.Type  
 left join tbl_FinanceUserRole FR on FR.MenuID=FM.id    
 left join Tbl_New_Admission NA on NA.New_Admission_Id=C.New_Admission_Id  
 left join Tbl_Department D on D.Department_Id= NA.Department_Id  
  where [Types]!=''OnlinePayment'' and  FR.status=1 and (RoleID=@roleid)) and (RequestTypeId = @transactiontype or @transactiontype=0)  
   order by RequestId desc  
    end  
    if(@flag=2)----List Request Payment Amount------  
        begin  
            select RequestId,P.InvoiceId,C.paymentmethod,bankname,P.Amount as SubAmount,P.Remarks ,R.amount as Totalamount,t.docno  
            ,C.Remark as BankRemark,refno,Convert(varchar,C.refdocdate,103)as RefDate,Attachmenturl,Ledger,name  
            from Approval_Request R  
            left join Payment_Request P on R.RequestId=P.ApprovalRequestId  
            left join student_transaction t on t.transactionid=p.InvoiceId  
            left join  Candidate_Payment_BankDetails C on c.ApprovalRequestId=R.RequestId  
            left join ref_bank b on b.id=C.bankname  
            where R.RequestId=@RequestId  
        end  
        if(@flag=3)  
        begin  
          SELECT DISTINCT R.ApprovalRequestId, R.billId, R.Remarks, R.Amount, b.billid AS Expr1, a.name, R.Id AS requested_Id,  
                             (SELECT        SUM(adjustmentamount) AS Expr1  
                               FROM            dbo.student_payment AS p  
                               WHERE        (receiptid = R.receiptid)) AS adjustmentamount, t.transactionid, R.receiptid, t.docno, b.outstandingbalance, b.totalamountpaid, b.totalamountpayable, p.adjustmentamount AS adjAmt, p.amount AS amt  
   FROM            dbo.Refund_Request AS R INNER JOIN  
          dbo.student_payment AS p ON R.receiptid = p.receiptid LEFT OUTER JOIN  
          dbo.Refund_Request_Details AS RD ON R.ApprovalRequestId = RD.ApprovalRequestId LEFT OUTER JOIN  
          dbo.student_bill AS b ON b.billid = R.billId LEFT OUTER JOIN  
          dbo.ref_accountcode AS a ON a.id = b.accountcodeid LEFT OUTER JOIN  
          dbo.student_transaction AS t ON t.transactionid = RD.transactionid  
   WHERE        (R.ApprovalRequestId = @RequestId)  
     --select * ,R.billId,R.Amount,R.Remarks,a.name,t.docno,totalamountpaid,  
  --      outstandingbalance,totalamountpayable,receiptid,p.adjustmentamount  
  --      ,(p.amount-p.adjustmentamount)as amount,t.transactionid,t.studentid  
            
  --     from Refund_Request R  
  --      left join Refund_Request_Details RD on R.ApprovalRequestId=RD.ApprovalRequestId  
  --      left join student_bill b on b.billid = r.billId  
  --      left join ref_accountcode a on a.id = b.accountcodeid  
  --      left join student_transaction t on t.transactionid=RD.transactionid  
  --      left join student_payment p on r.billId=p.billid and t.transactionid=p.transactionid -- and p.billid=b.billid  
  --  where r.ApprovalRequestId=@RequestId  
            
        end  
        if(@flag=4)  
        begin  
            Update Approval_Request set ApprovalStatus=@ApprovalStatus,ApprovalBy=@ApprovalBy,  
            ApprovalDate=GETUTCDATE(),ApprovalRemark=@ApprovalRemark,amount=@amount,RefundStatus=@RefundStatus  
            where RequestId=@RequestId  
        end  
  if(@flag=5)  
        begin  
            Update Approval_Request set ApprovalStatus=@ApprovalStatus,ApprovalBy=@ApprovalBy,  
            ApprovalDate=GETUTCDATE(),RefundStatus=@RefundStatus  
            where RequestId=@RequestId  
        end  
  if(@flag=6)  
        begin  
           select * from Approval_Request  
            where RequestId=@RequestId  
        end  
  if(@flag=7)  
        begin  
         Update  Refund_Request set Status=0 where Id=@RequestId  
        end  
  if(@flag=8)  
        begin  
          select RD.ApprovalRequestId,AR.ApprovalStatus as Status,receiptid,RR.Amount from Refund_Request_Details RD  
     inner Join   Refund_Request RR on RD.ApprovalRequestId=RR.ApprovalRequestId  
     join Approval_Request AR on AR.RequestId = RR.ApprovalRequestId  
     where AR.ApprovalStatus=1 and transactionid=@RequestId--RD.ApprovalRequestId=@RequestId  
        end  
  if(@flag=9)--Update Approval Request Remark  
        begin  
         Update  Approval_Request set ApprovalBy=@ApprovalBy,ApprovalRemark = @ApprovalRemark where RequestId=@RequestId  
        end  
  if(@flag=10)----Refund Amount List-----  
  begin  
   --select (case when p.description <>'''' then  p.description else  A.name end) as description ,  
   --R.Amount as amount,p.billid,t.docno,t.transactionid,R.receiptid,  
   --p.receiptid,t.flagledger,p.canadjust  
   --from student_transaction t  
    
   --left join  student_payment p on p.transactionid=t.transactionid   
   --inner join Refund_Request R on R.receiptid=p.receiptid  
   --left JOIN dbo.ref_accountcode AS A ON p.accountcodeid = A.id   
   -- where t.transactionid=@RequestId  
   SELECT DISTINCT R.ApprovalRequestId, R.billId, R.Remarks, R.Amount as amount, b.billid,  
   (case when p.description <>'''' then  p.description else  A.name end) as description ,  
    a.name, R.Id AS requested_Id,  
                             (SELECT        SUM(adjustmentamount) AS Expr1  
                               FROM            dbo.student_payment AS p  
                               WHERE        (receiptid = R.receiptid)) AS adjustmentamount, t.transactionid, R.receiptid, t.docno, b.outstandingbalance, b.totalamountpaid, b.totalamountpayable, p.adjustmentamount AS adjAmt, p.amount AS amt  
   FROM            dbo.Refund_Request AS R INNER JOIN  
          dbo.student_payment AS p ON R.receiptid = p.receiptid LEFT OUTER JOIN  
          dbo.Refund_Request_Details AS RD ON R.ApprovalRequestId = RD.ApprovalRequestId LEFT OUTER JOIN  
          dbo.student_bill AS b ON b.billid = R.billId LEFT OUTER JOIN  
          dbo.ref_accountcode AS a ON a.id = b.accountcodeid LEFT OUTER JOIN  
          dbo.student_transaction AS t ON t.transactionid = RD.transactionid  
   WHERE        (R.ApprovalRequestId =@RequestId)  
  end   
    
END  
    ') 
END
ELSE
BEGIN
EXEC('

ALTER procedure [dbo].[All_Finance_Requests_List] 
    
    @flag int  
    ,@RequestId bigint =0  
    ,@ApprovalStatus bigint =0  
    ,@ApprovalBy bigint =0  
    ,@ApprovalDate Datetime=''''  
    ,@ApprovalRemark varchar(500)=''''  
    ,@amount decimal(18,0)=0  
 ,@transactiontype bigint =0  
 ,@roleid bigint=0  
 ,@RefundStatus bigint=0  
AS  
BEGIN  
     
if(@flag=1)----Select ApprovalRequests------  
        begin  
            Select distinct StudentId,RequestTypeId,ApprovalStatus , RequestId,T.[Types],R.ApprovalBy,D.Department_Name,  
   (case when C.Adharnumber='''' then ''-NA-'' when C.Adharnumber is null then ''-NA-'' else C.Adharnumber end)as Adharnumber,  
   (case when C.IDMatrixNo='''' then ''-NA-'' when C.IDMatrixNo is null then ''-NA-'' else C.IDMatrixNo end)as MetrixNo,  
   (case when cbd.Batch_Code='''' then ''-NA-'' when cbd.Batch_Code is null then ''-NA-'' else cbd.Batch_Code end)as Batch,  
            Candidate_Fname + '' ''+ Candidate_Lname AS StudentName ,  
               CASE WHEN ApprovalStatus = 1 and R.RefundStatus is null THEN ''Pending''  
                     WHEN ApprovalStatus = 2 and R.RefundStatus is null THEN ''Approved''  
      WHEN ApprovalStatus = 2 and R.RefundStatus=0 THEN ''Approved''  
      WHEN ApprovalStatus = 1 and R.RefundStatus=0 THEN ''Pending''  
                     WHEN ApprovalStatus = 3 THEN ''Rejected''  
      WHEN ApprovalStatus = 2 and R.RefundStatus=3 THEN ''Paid''  
      WHEN ApprovalStatus = 1 and R.RefundStatus=1 THEN ''Pending(Approved)''  
                     WHEN ApprovalStatus = 1 and R.RefundStatus=2 THEN ''Pending(Processing)''  
                    END AS StatusApproval,CONVERT(varchar, R.RequestDate,103)as RequestDate  
                    ,CONVERT(varchar,R.ApprovalDate,103) as ApprovalDate  
            from Approval_Request R  
            Left join Approval_Request_Type T on T.Id=R.RequestTypeId  
            left join Tbl_Candidate_Personal_Det C on C.Candidate_Id=R.StudentId  
   left join Tbl_New_Admission NA on NA.New_Admission_Id=C.New_Admission_Id  
         left join Tbl_Department D on D.Department_Id= NA.Department_Id   
   left join dbo.Tbl_Student_Semester SS on SS.Candidate_Id=C.Candidate_Id   and  SS.Student_Semester_Delete_Status=0 and   ss.student_semester_current_status=1                                
   left JOIN Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                                     
   left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id  
            where T.[Types] != ''OnlinePayment'' and (RequestTypeId = @transactiontype or @transactiontype = 0 )  
   and (ApprovalStatus = @ApprovalStatus or @ApprovalStatus = 0 )  
   and RequestTypeId in (select distinct AR.Id from Approval_Request_Type AR  
 left join tbl_FinanceAccessMaster FM on AR.Id=FM.Type  
 left join tbl_FinanceUserRole FR on FR.MenuID=FM.id    
 left join Tbl_New_Admission NA on NA.New_Admission_Id=C.New_Admission_Id  
 left join Tbl_Department D on D.Department_Id= NA.Department_Id  
  where [Types]!=''OnlinePayment'' and  FR.status=1 and (RoleID=@roleid)) and (RequestTypeId = @transactiontype or @transactiontype=0)  
   order by RequestId desc  
    end  
    if(@flag=2)----List Request Payment Amount------  
        begin  
            select RequestId,P.InvoiceId,C.paymentmethod,bankname,P.Amount as SubAmount,P.Remarks ,R.amount as Totalamount,t.docno  
            ,C.Remark as BankRemark,refno,Convert(varchar,C.refdocdate,103)as RefDate,Attachmenturl,Ledger,name  
            from Approval_Request R  
            left join Payment_Request P on R.RequestId=P.ApprovalRequestId  
            left join student_transaction t on t.transactionid=p.InvoiceId  
            left join  Candidate_Payment_BankDetails C on c.ApprovalRequestId=R.RequestId  
            left join ref_bank b on b.id=C.bankname  
            where R.RequestId=@RequestId  
        end  
        if(@flag=3)  
        begin  
          SELECT DISTINCT R.ApprovalRequestId, R.billId, R.Remarks, R.Amount, b.billid AS Expr1, a.name, R.Id AS requested_Id,  
                             (SELECT        SUM(adjustmentamount) AS Expr1  
                               FROM            dbo.student_payment AS p  
                               WHERE        (receiptid = R.receiptid)) AS adjustmentamount, t.transactionid, R.receiptid, t.docno, b.outstandingbalance, b.totalamountpaid, b.totalamountpayable, p.adjustmentamount AS adjAmt, p.amount AS amt  
   FROM            dbo.Refund_Request AS R INNER JOIN  
          dbo.student_payment AS p ON R.receiptid = p.receiptid LEFT OUTER JOIN  
          dbo.Refund_Request_Details AS RD ON R.ApprovalRequestId = RD.ApprovalRequestId LEFT OUTER JOIN  
          dbo.student_bill AS b ON b.billid = R.billId LEFT OUTER JOIN  
          dbo.ref_accountcode AS a ON a.id = b.accountcodeid LEFT OUTER JOIN  
          dbo.student_transaction AS t ON t.transactionid = RD.transactionid  
   WHERE        (R.ApprovalRequestId = @RequestId)  
     --select * ,R.billId,R.Amount,R.Remarks,a.name,t.docno,totalamountpaid,  
  --      outstandingbalance,totalamountpayable,receiptid,p.adjustmentamount  
  --      ,(p.amount-p.adjustmentamount)as amount,t.transactionid,t.studentid  
            
  --     from Refund_Request R  
  --      left join Refund_Request_Details RD on R.ApprovalRequestId=RD.ApprovalRequestId  
  --      left join student_bill b on b.billid = r.billId  
  --      left join ref_accountcode a on a.id = b.accountcodeid  
  --      left join student_transaction t on t.transactionid=RD.transactionid  
  --      left join student_payment p on r.billId=p.billid and t.transactionid=p.transactionid -- and p.billid=b.billid  
  --  where r.ApprovalRequestId=@RequestId  
            
        end  
        if(@flag=4)  
        begin  
            Update Approval_Request set ApprovalStatus=@ApprovalStatus,ApprovalBy=@ApprovalBy,  
            ApprovalDate=GETUTCDATE(),ApprovalRemark=@ApprovalRemark,amount=@amount,RefundStatus=@RefundStatus  
            where RequestId=@RequestId  
        end  
  if(@flag=5)  
        begin  
            Update Approval_Request set ApprovalStatus=@ApprovalStatus,ApprovalBy=@ApprovalBy,  
            ApprovalDate=GETUTCDATE(),RefundStatus=@RefundStatus  
            where RequestId=@RequestId  
        end  
  if(@flag=6)  
        begin  
           select * from Approval_Request  
            where RequestId=@RequestId  
        end  
  if(@flag=7)  
        begin  
         Update  Refund_Request set Status=0 where Id=@RequestId  
        end  
  if(@flag=8)  
        begin  
          select RD.ApprovalRequestId,AR.ApprovalStatus as Status,receiptid,RR.Amount from Refund_Request_Details RD  
     inner Join   Refund_Request RR on RD.ApprovalRequestId=RR.ApprovalRequestId  
     join Approval_Request AR on AR.RequestId = RR.ApprovalRequestId  
     where AR.ApprovalStatus=1 and transactionid=@RequestId--RD.ApprovalRequestId=@RequestId  
        end  
  if(@flag=9)--Update Approval Request Remark  
        begin  
         Update  Approval_Request set ApprovalBy=@ApprovalBy,ApprovalRemark = @ApprovalRemark where RequestId=@RequestId  
        end  
  if(@flag=10)----Refund Amount List-----  
  begin  
   --select (case when p.description <>'''' then  p.description else  A.name end) as description ,  
   --R.Amount as amount,p.billid,t.docno,t.transactionid,R.receiptid,  
   --p.receiptid,t.flagledger,p.canadjust  
   --from student_transaction t  
    
   --left join  student_payment p on p.transactionid=t.transactionid   
   --inner join Refund_Request R on R.receiptid=p.receiptid  
   --left JOIN dbo.ref_accountcode AS A ON p.accountcodeid = A.id   
   -- where t.transactionid=@RequestId  
   SELECT DISTINCT R.ApprovalRequestId, R.billId, R.Remarks, R.Amount as amount, b.billid,  
   (case when p.description <>'''' then  p.description else  A.name end) as description ,  
    a.name, R.Id AS requested_Id,  
                             (SELECT        SUM(adjustmentamount) AS Expr1  
                               FROM            dbo.student_payment AS p  
                               WHERE        (receiptid = R.receiptid)) AS adjustmentamount, t.transactionid, R.receiptid, t.docno, b.outstandingbalance, b.totalamountpaid, b.totalamountpayable, p.adjustmentamount AS adjAmt, p.amount AS amt  
   FROM            dbo.Refund_Request AS R INNER JOIN  
          dbo.student_payment AS p ON R.receiptid = p.receiptid LEFT OUTER JOIN  
          dbo.Refund_Request_Details AS RD ON R.ApprovalRequestId = RD.ApprovalRequestId LEFT OUTER JOIN  
          dbo.student_bill AS b ON b.billid = R.billId LEFT OUTER JOIN  
          dbo.ref_accountcode AS a ON a.id = b.accountcodeid LEFT OUTER JOIN  
          dbo.student_transaction AS t ON t.transactionid = RD.transactionid  
   WHERE        (R.ApprovalRequestId =@RequestId)  
  end   
    
END



')
END
