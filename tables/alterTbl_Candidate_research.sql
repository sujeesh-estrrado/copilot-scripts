IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'Tbl_Candidate_research' 
    AND COLUMN_NAME = 'Delete_Status'
)
BEGIN
    ALTER TABLE [dbo].[Tbl_Candidate_research] 
    ADD [Delete_Status] [bit] NULL;
END
