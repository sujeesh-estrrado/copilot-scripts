IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_OutstandingApplicationFeeInvoice]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_OutstandingApplicationFeeInvoice]
(@studentid bigint =0)
as
begin
	select *
	from student_bill 
	where billgroupid  in  (select billgroupid from student_transaction where semesterno = -1 and outstandingbalance>0 and studentid=@studentid and billcancel = 0)
end 
');
END