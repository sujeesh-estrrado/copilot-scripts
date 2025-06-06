IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Agent_Invoice_ApprovalStatus]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Update_Agent_Invoice_ApprovalStatus] 
        (@Invoiceno VARCHAR(MAX), 
         @Approval_status BIT, 
         @Approved_By BIGINT)
        AS
        BEGIN 
            UPDATE dbo.Tbl_Agent_Invoice
            SET Approval_status = @Approval_status, 
                Approved_By = @Approved_By, 
                Approved_date = GETDATE() 
            WHERE Invoiceno = @Invoiceno;
        END
    ')
END
