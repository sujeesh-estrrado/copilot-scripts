IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_Student_Uploaded_Invoice_Doc]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Get_Student_Uploaded_Invoice_Doc]
    -- Add the parameters for the stored procedure here
    @InvoiceId bigint=0,
    @CandidateId bigint=0

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT * FROM Tbl_Student_Invoice_Upload_Doc WHERE InvoiceId =@InvoiceId and CandidateId=@CandidateId and DelStatus=0
END
    ')
END;
