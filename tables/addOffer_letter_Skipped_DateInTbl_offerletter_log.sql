IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'Tbl_offerletter_log'
    AND COLUMN_NAME = 'Offer_letter_Skipped_Date'
)
BEGIN
    ALTER TABLE [dbo].[Tbl_offerletter_log]
    ADD [Offer_letter_Skipped_Date] DATETIME;
END
