IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'Tbl_FollowUp_Detail' 
    AND COLUMN_NAME = 'LeadStatus_Id'
)
BEGIN
    ALTER TABLE [dbo].[Tbl_FollowUp_Detail] 
    ADD [LeadStatus_Id] [bigint] NULL;
END
