IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'tbl_StudentDocUpload'
    AND COLUMN_NAME = 'IsInternal'
)
BEGIN
    ALTER TABLE [dbo].[tbl_StudentDocUpload]
    ADD [IsInternal] BIT NOT NULL DEFAULT 0;
END
