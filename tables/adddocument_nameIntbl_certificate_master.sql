IF EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'tbl_certificate_master'
    AND COLUMN_NAME = 'document_name'
)
BEGIN
    ALTER TABLE [dbo].[tbl_certificate_master]
    ALTER COLUMN [document_name] VARCHAR(250);
END
