IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_DN_CN_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[Sp_Get_DN_CN_Details]-- 3538
    -- Sp_Get_DN_CN_Details 1122
    @transactionid bigint
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
    select t.amount,t.description,t.amount as totalamount,t.docno,CONVERT(varchar, t.dateissued, 105) as dateissued,a.taxcode_id,t.refdocno,t.refdocdate,
    (case when a.taxcode_id is null then ''E'' when a.taxcode_id=''0'' then ''E'' when a.taxcode_id='''' then ''E'' else a.taxcode_id end) As reftaxcode,
    t.cashierid , t.studentid,remarks
 from student_transaction t
left join ref_accountcode A on t.accountcodeid=A.id

where t.transactionid=@transactionid




END');
END;
