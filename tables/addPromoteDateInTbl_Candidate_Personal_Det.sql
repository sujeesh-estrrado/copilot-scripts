IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'Tbl_Candidate_Personal_Det'
    AND COLUMN_NAME = 'PromoteDate'
)
BEGIN
    ALTER TABLE [dbo].[Tbl_Candidate_Personal_Det]
    ADD [PromoteDate] DATE;
END
