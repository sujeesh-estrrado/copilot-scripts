IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'Tbl_Class_TimeTable'
    AND COLUMN_NAME = 'merged_status'
)
BEGIN
    ALTER TABLE [dbo].[Tbl_Class_TimeTable]
    ADD [merged_status] INT DEFAULT 0;
END
