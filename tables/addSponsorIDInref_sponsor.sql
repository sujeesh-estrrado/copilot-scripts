IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'ref_sponsor'
    AND COLUMN_NAME = 'SponcerID'
)
BEGIN
    ALTER TABLE [dbo].[ref_sponsor]
    ADD [SponcerID] VARCHAR(50);
END
