IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Payment_Requests]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[Payment_Requests]
    @flag int =0,
    @RequestId bigint=0,
    @Types bigint=0,
    @StudentId bigint=0,
    @Date datetime='''',
    @status bigint=0,
    @ApprovalBy bigint=0,
    @Remark varchar(500)='''',
    @amount decimal(18, 2)=0,
    @paymentmethod bigint=0,
    @bankname bigint=0,
    @refno varchar(50)='''',
    @refdocdate datetime='''',
    @Attachmenturl varchar(max)='''',
    @InvoiceId bigint = 0,
    @flagledger char(10)='''',
    @TransactionID varchar(MAX)='''',
    @result int =0 output ,
    @accountcodeid bigint=0,
    @InvType varchar(50)=''''

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    --SET NOCOUNT ON;

    -- Insert statements for procedure here
    if(@flag=1)---Insert ApprovalRequest---
        begin
            insert into  [dbo].[Approval_Request](RequestTypeId,StudentId,RequestDate,ApprovalStatus,FlagLedger)
            values (@Types,@StudentId,GETUTCDATE(),1,@flagledger)
            set @result=SCOPE_IDENTITY()
            select @result as Approval_RequestId
        end
    if(@flag=2)----Insert PaymentRequest------
        begin
            insert into [dbo].[Payment_Request] (ApprovalRequestId,[Type],InvoiceId,Amount,[Status],Remarks,AccountCodeID,InvType)
            Values(@RequestId,@Types,@InvoiceId,@amount,1,@Remark,@accountcodeid,@InvType)
        end
    if(@flag=3)----Insert CandidatePaymentBankDetails-----
        begin
            insert into [dbo].[Candidate_Payment_BankDetails](ApprovalRequestId,paymentmethod,Remark,bankname,refno,refdocdate,Ledger,Attachmenturl)
            values(@RequestId,@paymentmethod,@Remark,@bankname,@refno,@refdocdate,@flagledger,@Attachmenturl)

        end
    if(@flag=4)---Get ApprovalRequest---
    begin
SELECT  AR.RequestId, AR.RequestTypeId, AR.StudentId,RRD.Remarks,D.Department_Name,
            (case when Cp.Adharnumber='''' then ''-NA-'' when Cp.Adharnumber is null then ''-NA-'' else Cp.Adharnumber end)as Adharnumber,
            (case when Cp.IDMatrixNo='''' then ''-NA-'' when Cp.IDMatrixNo is null then ''-NA-'' else Cp.IDMatrixNo end)as MetrixNo,
            (case when cbd.Batch_Code='''' then ''-NA-'' when cbd.Batch_Code is null then ''-NA-'' else cbd.Batch_Code end)as Batch,
             CASE WHEN ApprovalStatus = 1 and AR.RefundStatus is null THEN ''Pending''
                     WHEN ApprovalStatus = 2 and AR.RefundStatus is null THEN ''Approved''
                     WHEN ApprovalStatus = 2 and AR.RefundStatus=0 THEN ''Approved''
                     WHEN ApprovalStatus = 1 and AR.RefundStatus=0 THEN ''Pending''
                     WHEN ApprovalStatus = 3 THEN ''Rejected''
                     WHEN ApprovalStatus = 2 and AR.RefundStatus=3 THEN ''Paid''
                    WHEN ApprovalStatus = 1 and AR.RefundStatus=1 THEN ''Pending(Approved)''
                     WHEN ApprovalStatus = 1 and AR.RefundStatus=2 THEN ''Pending(Proccessing)''
                    END AS StatusApproval,
             AR.RequestDate, AR.ApprovalStatus, AR.ApprovalBy, AR.ApprovalDate, AR.ApprovalRemark, AR.amount, 
                    CONCAT(Cp.Candidate_Fname, '' '',Cp.Candidate_Lname) AS StudentName, AR.FlagLedger, 
                    CPBD.bankname as bankId,b.name as bankname, CPBD.refno, CPBD.Remark, CPBD.Attachmenturl, 
                Convert(varchar,CPBD.refdocdate,103)refdocdate, CONVERT(VARCHAR(10),  CPBD.refdocdate, 103) as refdocdate, CPBD.paymentmethod
        FROM    dbo.Approval_Request AS AR left JOIN
                    dbo.Tbl_Candidate_Personal_Det AS Cp ON AR.StudentId = Cp.Candidate_Id left JOIN
                    dbo.Candidate_Payment_BankDetails AS CPBD ON AR.RequestId = CPBD.ApprovalRequestId
                    left join ref_bank b on b.id=CPBD.bankname
                    left join [Refund_Request_Details] RRD on RRD.ApprovalRequestId=AR.RequestId
                    left join Tbl_New_Admission NA on NA.New_Admission_Id=Cp.New_Admission_Id
                    left join Tbl_Department D on D.Department_Id= NA.Department_Id 
                    left join dbo.Tbl_Student_Semester SS on SS.Candidate_Id=Cp.Candidate_Id   and  SS.Student_Semester_Delete_Status=0 and   ss.student_semester_current_status=1                              
                    left JOIN Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                                   
                    left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id                  
                    left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id 
        where   RequestId = @RequestId
    end
    if(@flag=5)---Get PaymentRequest By RequestId---
    begin
       select 
       CASE WHEN InvType=''INV'' THEN (b.docno + '' - '' +b.description)
        WHEN InvType=''Insta'' THEN IB.docno
                    END as Invoice
            , 
       p.InvoiceId, p.Amount,
       CASE WHEN InvType=''INV'' THEN b.totalamountpayable 
        WHEN InvType=''Insta'' THEN IB.totalamountpayable
                    END as totalamountpayable
            ,   CASE WHEN InvType=''INV'' THEN b.totalamountpaid 
        WHEN InvType=''Insta'' THEN IB.totalamountpaid
                    END as totalamountpaid,CASE WHEN InvType=''INV'' THEN b.totalamountpaid 
        WHEN InvType=''Insta'' THEN IB.outstandingbalance
                    END as outstandingbalance,InvType,
            CASE WHEN [ApprovalStatus]=1 THEN ''Pending'' 
                WHEN [ApprovalStatus]=2 THEN ''Approved'' 
                WHEN [ApprovalStatus] =3 THEN ''Reject'' 
                END as [Status],
            Remarks,ApprovalRequestId,[Type]
        from [Payment_Request] p
        left join student_bill b on p.InvoiceId=b.billid  and p.InvType=''INV''
        left join Approval_Request A on p.ApprovalRequestId=A.RequestId
        left join Tbl_Installment_Bills IB on IB.billid = p.InvoiceId and p.InvType=''Insta''
        where ApprovalRequestId = @RequestId
    end

    if(@flag=6)---Approve Payment Online---
    begin
        update Approval_Request set ApprovalStatus = 2, ApprovalBy =0,ApprovalDate = getdate(),ApprovalRemark = CONCAT( ''Online , Trnsaction No:'',@TransactionID),amount = @amount
        where RequestId = @RequestId
    end

    if(@flag=7)---Payment Request List---
    begin
        select CONVERT(varchar,R.RequestDate,103) as RequestDate,CONVERT(varchar,R.ApprovalDate,103) as ApprovalDate,ApprovalStatus
        , CASE WHEN ApprovalStatus = 1 THEN ''Pending''
                     WHEN ApprovalStatus = 2 THEN ''Approved''
                     WHEN ApprovalStatus = 3 THEN ''Reject''
                    END AS StatusApproval,p.amount as Requestamount,R.RequestId
        from Approval_Request R 
        left join Payment_Request p on R.RequestId=p.ApprovalRequestId
        where RequestTypeId=1 and StudentId=@StudentId
    end
    if(@flag=8)---Get PaymentRequest By RequestId---
    begin
        select  
CASE WHEN InvType=''INV'' THEN (b.docno + '' - '' +b.description)
        WHEN InvType=''Insta'' THEN IB.docno
                    END as Invoice
            , 
        p.InvoiceId, CONVERT(varchar(10),p.Amount) as Amount,

        CASE WHEN InvType=''INV'' THEN b.totalamountpayable 
        WHEN InvType=''Insta'' THEN IB.totalamountpayable
                    END as totalamountpayable
            ,   CASE WHEN InvType=''INV'' THEN b.totalamountpaid 
        WHEN InvType=''Insta'' THEN IB.totalamountpaid
                    END as totalamountpaid,CASE WHEN InvType=''INV'' THEN b.totalamountpaid 
        WHEN InvType=''Insta'' THEN IB.outstandingbalance
                    END as outstandingbalance,
        
        p.AccountCodeId,ra.name,
        CASE WHEN [ApprovalStatus]=1 THEN ''Pending'' WHEN [ApprovalStatus]=2 THEN ''Approved'' WHEN [ApprovalStatus] =3 THEN ''Reject'' END as [Status],Remarks,ApprovalRequestId,[Type],InvType
        from [Payment_Request] p
        left join student_bill b on p.InvoiceId=b.billid and p.InvType=''INV''
        left join Approval_Request A on p.ApprovalRequestId=A.RequestId
        left join ref_accountcode ra on p.AccountCodeID=ra.id
        left join Tbl_Installment_Bills IB on IB.billid = p.InvoiceId and p.InvType=''Insta''
        where ApprovalRequestId = @RequestId
    end
    if(@flag=9)---Get ApprovalRequests of type payment by student id---
    begin
        SELECT        CONVERT(varchar, RequestDate, 103) AS RequestDate, CONVERT(varchar, ApprovalDate, 103) AS ApprovalDate, ApprovalStatus, 
                             CASE WHEN ApprovalStatus = 1 THEN ''Pending'' WHEN ApprovalStatus = 2 THEN ''Approved'' WHEN ApprovalStatus = 3 THEN ''Reject'' END AS StatusApproval, RequestId, amount as Requestamount, RequestTypeId
        FROM            dbo.Approval_Request AS R
        WHERE        (RequestTypeId = 1) AND (StudentId = @StudentId)
    end
    if(@flag=10)---Update Total amount of Approval_Request
    begin
        UPDATE p
        SET p.amount = t.sumPrice
        FROM Approval_Request AS p
        INNER JOIN
            (
                SELECT ApprovalRequestId, SUM(AMOUNT) sumPrice
                FROM Payment_Request
                GROUP BY ApprovalRequestId 
            ) t
            ON t.ApprovalRequestId = p.RequestId
            where p.RequestId = @RequestId
    end
        if(@flag=11)---get all refund Request
    begin
        Select distinct StudentId,RequestTypeId,ApprovalStatus,T.[Types],RD.ApprovalRequestId,
        case when R.ApprovalBy is null then ''N/A'' when R.ApprovalBy=0 then ''N/A'' when R.ApprovalBy=1 then ''Admin''
        else concat(E.Employee_Fname,'' '',E.Employee_Lname)end as ApprovalBy,
        D.Department_Name,CONVERT(varchar, R.RequestDate,103)as RequestDate,
        case when R.ApprovalDate='''' then ''N/A'' when  R.ApprovalDate is null then ''N/A'' else CONVERT(varchar,R.ApprovalDate,103) end as ApprovalDate,
        sum(RR.Amount) as Requestamount,sum(R.amount) as Approvedamount,transactionid,

               CASE WHEN ApprovalStatus = 1 and R.RefundStatus is null THEN ''Pending''
                     WHEN ApprovalStatus = 2 and R.RefundStatus is null THEN ''Approved''
                     WHEN ApprovalStatus = 2 and R.RefundStatus=0 THEN ''Approved''
                     WHEN ApprovalStatus = 1 and R.RefundStatus=0 THEN ''Pending''
                     WHEN ApprovalStatus = 3 THEN ''Rejected''
                     WHEN ApprovalStatus = 2 and R.RefundStatus=3 THEN ''Paid''
                     WHEN ApprovalStatus = 1 and R.RefundStatus=1 THEN ''Pending(Approved)''
                     WHEN ApprovalStatus = 1 and R.RefundStatus=2 THEN ''Pending(Processing)''
                    END AS StatusApproval
                    
           
            from Refund_Request_Details RD
              inner Join   Refund_Request RR on RD.ApprovalRequestId=RR.ApprovalRequestId
              join Approval_Request R on R.RequestId = RR.ApprovalRequestId
            Left join Approval_Request_Type T on T.Id=R.RequestTypeId
            left join Tbl_Employee E on E.Employee_Id=R.ApprovalBy
            left join Tbl_Candidate_Personal_Det C on C.Candidate_Id=R.StudentId
            left join Tbl_New_Admission NA on NA.New_Admission_Id=C.New_Admission_Id
            left join Tbl_Department D on D.Department_Id= NA.Department_Id 
            left join dbo.Tbl_Student_Semester SS on SS.Candidate_Id=C.Candidate_Id   and  SS.Student_Semester_Delete_Status=0 and   ss.student_semester_current_status=1                              
            left JOIN Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                                   
            left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id                  
            left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id 
            where T.[Types] != ''OnlinePayment'' 
            and RequestTypeId in (select distinct AR.Id from Approval_Request_Type AR
                left join tbl_FinanceAccessMaster FM on AR.Id=FM.Type
                left join tbl_FinanceUserRole FR on FR.MenuID=FM.id  
                left join Tbl_New_Admission NA on NA.New_Admission_Id=C.New_Admission_Id
                left join Tbl_Department D on D.Department_Id= NA.Department_Id
                where [Types]!=''OnlinePayment'' and  FR.status=1 ) 
        and R.StudentId = @StudentId and T.Id=2
        group by R.StudentId,RequestTypeId,ApprovalStatus,T.[Types],
        R.ApprovalBy ,ApprovalStatus,RefundStatus,E.Employee_Fname,E.Employee_Lname,
        D.Department_Name, R.RequestDate,R.ApprovalDate,transactionid,RD.ApprovalRequestId
        
    end
END
    ')
END
