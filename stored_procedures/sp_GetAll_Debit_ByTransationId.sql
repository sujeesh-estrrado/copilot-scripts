IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetAll_Debit_ByTransationId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure  [dbo].[sp_GetAll_Debit_ByTransationId]
	-- [dbo].[sp_GetAll_Debit_ByTransationId]1077
	@Tid bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select P.[description],P.Amount ,t.docno
	from student_payment p
	left join student_transaction t on t.transactionid=P.transactionid
	 where  P.transactionid=@Tid



END

');
END;