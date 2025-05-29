IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_PendingBills]')
    AND type = N'P'
)
BEGIN
    EXEC('
     CREATE procedure [dbo].[Sp_Get_PendingBills]
(@flag bigint =0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if(@flag = 10)
	begin
		select b.billid, b.studentid, accountcodeid,bg.docno,totalamount,totalamountpaid,totalamountpayable,b.[description],
		name as AccountCode,B.outstandingbalance,Bg.billgroupid, b.datecreated,(SELECT DATEDIFF(DAY, b.datecreated,getdate()) AS DAYDIFF) as PendingDays
		from student_bill b 
		left join student_bill_group bg on b.billgroupid=bg.billgroupid
		left join ref_accountcode A on b.accountcodeid=A.id
		where outstandingbalance > 0 
		AND (b.billcancel = 0)
		and (SELECT DATEDIFF(DAY, b.datecreated,getdate()) AS DAYDIFF) = 9
	end
	if(@flag = 14)
	begin
		select b.billid, b.studentid, accountcodeid,bg.docno,totalamount,totalamountpaid,totalamountpayable,b.[description],
		name as AccountCode,B.outstandingbalance,Bg.billgroupid, b.datecreated,(SELECT DATEDIFF(DAY, b.datecreated,getdate()) AS DAYDIFF) as PendingDays
		from student_bill b 
		left join student_bill_group bg on b.billgroupid=bg.billgroupid
		left join ref_accountcode A on b.accountcodeid=A.id
		where outstandingbalance > 0 
		AND (b.billcancel = 0)
		and (SELECT DATEDIFF(DAY, b.datecreated,getdate()) AS DAYDIFF) = 13
	end
	if(@flag = 15)
	begin
		select b.billid, b.studentid, accountcodeid,bg.docno,totalamount,totalamountpaid,totalamountpayable,b.[description],
		name as AccountCode,B.outstandingbalance,Bg.billgroupid, b.datecreated,(SELECT DATEDIFF(DAY, b.datecreated,getdate()) AS DAYDIFF) as PendingDays
		from student_bill b 
		left join student_bill_group bg on b.billgroupid=bg.billgroupid
		left join ref_accountcode A on b.accountcodeid=A.id
		where outstandingbalance > 0 
		AND (b.billcancel = 0)
		and (SELECT DATEDIFF(DAY, b.datecreated,getdate()) AS DAYDIFF) = 14
	end
	if(@flag = 21)
	begin
		select b.billid, b.studentid, accountcodeid,bg.docno,totalamount,totalamountpaid,totalamountpayable,b.[description],
		name as AccountCode,B.outstandingbalance,Bg.billgroupid, b.datecreated,(SELECT DATEDIFF(DAY, b.datecreated,getdate()) AS DAYDIFF) as PendingDays
		from student_bill b 
		left join student_bill_group bg on b.billgroupid=bg.billgroupid
		left join ref_accountcode A on b.accountcodeid=A.id
		where outstandingbalance > 0 
		AND (b.billcancel = 0)
		and (SELECT DATEDIFF(DAY, b.datecreated,getdate()) AS DAYDIFF) = 20
	end
	if(@flag = 30)
	begin
		select b.billid, b.studentid, accountcodeid,bg.docno,totalamount,totalamountpaid,totalamountpayable,b.[description],
		name as AccountCode,B.outstandingbalance,Bg.billgroupid, b.datecreated,(SELECT DATEDIFF(DAY, b.datecreated,getdate()) AS DAYDIFF) as PendingDays
		from student_bill b 
		left join student_bill_group bg on b.billgroupid=bg.billgroupid
		left join ref_accountcode A on b.accountcodeid=A.id
		where outstandingbalance > 0 
		AND (b.billcancel = 0)
		and (SELECT DATEDIFF(DAY, b.datecreated,getdate()) AS DAYDIFF) = 29
	end
END
--select * from student_bill_group
    ')
END
GO
