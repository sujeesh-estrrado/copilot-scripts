IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_refund_Dtls]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Get_refund_Dtls]
    @StudentID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT docno FROM student_transaction
where studentid = @StudentID and description =''Payment'';
END;
    ')
END;
