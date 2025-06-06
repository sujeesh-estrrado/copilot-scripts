IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Test_StudentFinance]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        create procedure [dbo].[sp_Test_StudentFinance] 
(
@studentid bigint =0
)
as
begin
    select * from student_payment_float where studentid=@studentid
    select * from student_bill where studentid=@studentid
    select * from student_bill_group where studentid  =@studentid
    select * from student_transaction  where studentid=@studentid
    select * from student_payment   where studentid=@studentid
    select billoutstanding from Tbl_Candidate_Personal_Det where Candidate_Id=@studentid
    select * from Tbl_AutoInvoiceLog   where studentid=@studentid
    select * from Approval_Request   where studentid=@studentid
end
    ')
END
