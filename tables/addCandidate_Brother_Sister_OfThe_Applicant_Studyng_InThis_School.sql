IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'Tbl_Candidate_Additional_Details'
    AND COLUMN_NAME = 'Candidate_Brother_Sister_OfThe_Applicant_Studyng_InThis_School'
)
BEGIN
    ALTER TABLE [dbo].[Tbl_Candidate_Additional_Details]
    ADD [Candidate_Brother_Sister_OfThe_Applicant_Studyng_InThis_School] VARCHAR(500);
END
