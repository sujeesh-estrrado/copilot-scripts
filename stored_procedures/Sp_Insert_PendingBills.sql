IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Insert_PendingBills]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Insert_PendingBills]
	-- Add the parameters for the stored procedure here
	@transactionid bigint=0,
	@flag bigint=0,
	@StudentId bigint=0,
	@cashierid bigint=0,
	@courseid bigint=0,
	@accountcodeid bigint=0,
	@billId bigint=0,
	@billgroupid bigint=0,
	@refno bigint=0,
	@bankName varchar(10)='''',
	@receiptnumber varchar(20)='''',
	@docno varchar(50)='''',
	@description varchar(255)='''',
	@amount decimal(18, 2)=0,
	@totalamountpayable decimal(18, 2)=0,
	@totalamountpaid decimal(18, 2)=0,
	@outstandingbalance decimal(18, 2)=0, 
	@totalamount decimal(18, 2)=0,
	@paymentmethod bigint=0,
	@transactiontype bigint=0,
	@remarks varchar(255)='''',
	@datetimeissued datetime='''',
	@balance decimal(18, 2)=0,
	--@dateissued datetime,
	@datedue datetime='''',
	@checkdate datetime='''',
	@flagledger char(10)='''',
	@createdby bigint=0

	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--SET NOCOUNT ON;
	declare @result  int 

	if(@flag=1) --Insert student transaction
		begin
			if not exists(select * from student_transaction  where docno=@docno )
		begin

			
			Insert into student_transaction(docno,[description],amount,
					paymentmethod,transactiontype,remarks,datetimeissued,dateissued,
					cashierid,studentid,courseid,flagledger)
					values(@docno,@description,@amount,@paymentmethod,
					@transactiontype,@remarks,@datetimeissued,GETUTCDATE(),@cashierid,@StudentId,@courseid,@flagledger)

					set @result=@@IDENTITY

		end
	else 
		begin
		 
			Update  student_transaction set balance=@balance
			
			where  docno=@docno
		end
		end
	if(@flag=2) --Payment Insert
	
		begin
			Insert into student_payment (accountcodeid,receiptnumber,
			[description],amount,paymentmethod,datetimeissued,cashierid,
			studentid,transactionid,billid,dateissued,bankname,refno,checkdate,flagledger)
			values(@accountcodeid,@receiptnumber,@description,@amount,@paymentmethod,
			@datetimeissued,@cashierid,@StudentId,@transactionid,@billId,GETUTCDATE(),@bankName,@refno,
			@checkdate,@flagledger)
			set @result=@@IDENTITY
		end
	if(@flag=3)--Insert into Payment Float
		begin
			insert into student_payment_float(studentid,floatamount,flagLedger,accountcodeid)
			values (@StudentId,@amount,@flagledger,@accountcodeid)
			
		end
	if(@flag=4)--Insert Bill to Student_bill table
		begin
			Insert into student_bill(docno,accountcodeid,[description],studentid,
			totalamountpayable,totalamountpaid,outstandingbalance,billgroupid,
			flagledger,datecreated,createdby)
			values(@docno,@accountcodeid,@description,@StudentId,@totalamountpayable,
			@totalamountpaid,@outstandingbalance,@billgroupid,@flagledger,GETUTCDATE(),@createdby)
			set @result=@@IDENTITY
		end

		if(@flag=5)--Insert Bill to Student_bill table
		begin

			Update student_bill 
			set totalamountpaid=@totalamountpaid,outstandingbalance=@outstandingbalance,
			dateupdated=GETUTCDATE(),updatedby=@createdby

			where billid=@billId
		end
	if(@flag=6)--- Genaration condition yes thne Insert bill 
		begin
			insert into student_bill_group(docno,studentid,totalamount,dateissued,
			flagledger,datedue,datecreated,createdby)
			values(@docno,@StudentId,@totalamount,GETUTCDATE(),@flagledger,@datedue,GETUTCDATE(),@createdby)
			set @result=@@IDENTITY
		end
		if(@flag=7)--Update to Payment Float amount
		begin

			Update student_payment_float 
			set floatamount=@amount
			where flagLedger=@flagledger and studentid=@StudentId and accountcodeid = @accountcodeid
		end
		if(@flag=8)--get iPayment Float by flagledger and StudentId
		begin
			select paymentfloatid, studentid,floatamount,flagLedger,accountcodeid from student_payment_float
			where flagLedger=@flagledger and studentid=@StudentId and floatamount >0
		end
		if(@flag=9)--get Payment Float by flagledger, StudentId and AccountCode
		begin
			select paymentfloatid, studentid,floatamount,flagLedger,accountcodeid from student_payment_float
			where flagLedger=@flagledger and studentid=@StudentId and (accountcodeid = @accountcodeid or @accountcodeid = 0)
		end
		if(@flag=10)--Update to Payment Float amount with paymentfloatid
		begin

			Update student_payment_float 
			set floatamount=@amount
			where paymentfloatid = @StudentId
		end
		if(@flag=11)--get Float by StudentId 
		begin
			select paymentfloatid, studentid,floatamount,flagLedger,accountcodeid from student_payment_float
			where  studentid=@StudentId and floatamount >0
		end

END
   ');
END;
