IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Details_GetById]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[sp_Details_GetById]
    @transactionid bigint
AS
BEGIN
    select docno,[description],amount, CONVERT(varchar, dateissued, 101)dateissued from student_transaction
    where transactionid=@transactionid

END
    ')
END
