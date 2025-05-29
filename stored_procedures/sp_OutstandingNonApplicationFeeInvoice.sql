IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_OutstandingNonApplicationFeeInvoice]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_OutstandingNonApplicationFeeInvoice]  
(@studentid bigint =0)
as
begin
	select *
	from student_bill 
	where billgroupid  in  (select billgroupid from student_transaction where semesterno != -1 and studentid=12 and billcancel = 0 )
		and billcancel = 0
end
');
END