IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'Approval_Request'
    AND COLUMN_NAME = 'ApprovalRemark'
)
BEGIN
    ALTER TABLE [dbo].[Approval_Request]
    ADD [ApprovalRemark] VARCHAR(500);
END
