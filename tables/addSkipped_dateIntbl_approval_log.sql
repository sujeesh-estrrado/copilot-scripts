IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'tbl_approval_log'
    AND COLUMN_NAME = 'Skipped_date'
)
BEGIN
    ALTER TABLE [dbo].[tbl_approval_log]
    ADD [Skipped_date] DATETIME;
END
