IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'Tbl_Student_InvoiceUpload'
    AND COLUMN_NAME = 'IsModular'
)
BEGIN
    ALTER TABLE [dbo].[Tbl_Student_InvoiceUpload]
    ADD [IsModular] INT NOT NULL DEFAULT 0;
END
