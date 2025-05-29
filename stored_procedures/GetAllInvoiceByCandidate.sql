IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[GetAllInvoiceByCandidate]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[GetAllInvoiceByCandidate]
    -- Add the parameters for the stored procedure here
    @CandidateId bigint=0
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
select id InvoiceId,StudentId,InvoiceDescription,DocumentLoc,
    CONVERT(date, CreatedDate) AS CreatedDate, PaymentLink from Tbl_Student_InvoiceUpload where DeleteStatus=0

and StudentId=@CandidateId order by id desc
END
    ')
END;
