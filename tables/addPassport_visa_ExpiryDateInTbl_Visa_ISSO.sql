IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'Tbl_Visa_ISSO'
    AND COLUMN_NAME = 'Passport_visa_ExpiryDate'
)
BEGIN
    ALTER TABLE [dbo].[Tbl_Visa_ISSO]
    ADD [Passport_visa_ExpiryDate] DATE;
END
