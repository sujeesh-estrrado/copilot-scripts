IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetById_Receipt_Transactionid]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_GetById_Receipt_Transactionid] 
	--  [dbo].[Sp_GetById_Receipt_studentid]  
	@transactionid bigint
AS
BEGIN
	select t.docno,p.description,p.amount,CONVERT(varchar, t.dateissued, 1) as dateissued
	from student_transaction t 
	left join student_payment p on p.transactionid=t.transactionid

	where  t.transactionid=@transactionid


END');
END;
