IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'Tbl_Candidate_Personal_Det'
    AND COLUMN_NAME = 'Candidate_UpdatedDate'
)
BEGIN
    ALTER TABLE [dbo].[Tbl_Candidate_Personal_Det]
    ADD [Candidate_UpdatedDate] DATETIME;
END
