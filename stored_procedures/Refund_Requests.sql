IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Refund_Requests]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Refund_Requests]
    @flag int ,
    @RequestId bigint=0,
    @transactionid bigint=0,
    @Types bigint=0,
    @StudentId bigint=0,
    @Date datetime='''',
    @status bigint=0,
    @ApprovalBy bigint=0,
    @Remark varchar(500)='''',
    @amount decimal(18, 2)=0,
    @InvoiceId bigint = 0,
    @flagledger char(10)='''',
    @ApprovalRequestId bigint = 0,
    @receiptid bigint=0,
    @Id bigint=0,
    @result int =0 output 

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    --SET NOCOUNT ON;

    -- Insert statements for procedure here
    if(@flag=1)---Insert ApprovalRequest---
        begin
            insert into  [dbo].[Approval_Request](RequestTypeId,StudentId,RequestDate,ApprovalStatus)
            values (@Types,@StudentId,GETUTCDATE(),1)
            set @result=SCOPE_IDENTITY()
            select @result as Approval_RequestId
        end
    if(@flag=2)----Insert RefundRequest------
        begin
            insert into [dbo].[Refund_Request] (ApprovalRequestId,[Type],billId,Amount,[Status],Remarks,receiptid,Approved_Amount)
            Values(@RequestId,@Types,@InvoiceId,@amount,1,@Remark,@receiptid,@amount)
        end
    if(@flag=3)----Insert RefundDetails-----
        begin
            insert into [dbo].[Refund_Request_Details](ApprovalRequestId,Ledger,transactionid,Remarks)
            values(@RequestId,@flagledger,@transactionid,@Remark)
            --insert into [dbo].[Refund_Request_Details](ApprovalRequestId,Ledger,transactionid,Remarks,Amount)
            --values(@RequestId,@flagledger,@transactionid,@Remark,@Amount)
        end
    if(@flag=4)----Refund Amount List-----
        begin
            select (case when p.description <>'''' then  p.description else  A.name end) as description ,(p.amount-P.adjustmentamount)as amount,p.billid ,t.docno,t.transactionid,receiptid,t.flagledger,p.canadjust
            from student_transaction t
            left join  student_payment p on p.transactionid=t.transactionid left JOIN
                         dbo.ref_accountcode AS A ON p.accountcodeid = A.id 
             where t.transactionid=@transactionid
        end 
    if(@flag=5)
        begin
            select R.billId,R.Amount,R.Remarks,a.name
            from Refund_Request R
            left join Refund_Request_Details RD on R.ApprovalRequestId=RD.ApprovalRequestId
            left join student_bill b on b.billid = r.billId
            left join ref_accountcode a on a.id = b.accountcodeid
            where r.ApprovalRequestId=@ApprovalRequestId
        end

        if(@flag=6)----Update RefundRequest Amount------
        begin
            update [Refund_Request] 
            set Amount = @amount ,Approved_Amount=@amount
            where Id = @Id 
        
        end
        if(@flag=7)---Insert ApprovalRequest---
        begin
            insert into  [dbo].[Approval_Request](RequestTypeId,StudentId,RequestDate,ApprovalStatus,FlagLedger)
            values (@Types,@StudentId,GETUTCDATE(),1,@flagledger)
            set @result=SCOPE_IDENTITY()
            select @result as Approval_RequestId
        end
        if(@flag=8)---get ApprovalRequest---
        begin
        select * from Refund_Request_Details where ApprovalRequestId=@ApprovalRequestId
            
        end
            
END
    ');
END;
GO
