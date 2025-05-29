IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Update_Student_Uploaded_Invoice_VerificationStatus]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Update_Student_Uploaded_Invoice_VerificationStatus]
    -- Add the parameters for the stored procedure here
    @Id bigint=0,
    @CandidateId bigint=0,
    @VerificationStatus varchar(10)=''''


AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
    UPDATE  Tbl_Student_Invoice_Upload_Doc SET VerificationStatus=@VerificationStatus WHERE Id =@Id and CandidateId=@CandidateId
END
    ')
END;
