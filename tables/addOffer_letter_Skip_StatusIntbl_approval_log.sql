IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'tbl_approval_log'
    AND COLUMN_NAME = 'Offer_letter_Skip_Status'
)
BEGIN
    ALTER TABLE [dbo].[tbl_approval_log]
    ADD [Offer_letter_Skip_Status] INT;
END
