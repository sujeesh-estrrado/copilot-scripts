IF EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'tbl_Notice_Board'
    AND COLUMN_NAME = 'Annoncement'
)
BEGIN
    ALTER TABLE [dbo].[tbl_Notice_Board]
    ALTER COLUMN [Annoncement] VARCHAR(MAX) NULL;
END
