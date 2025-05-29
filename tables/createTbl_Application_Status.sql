-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Application_Status]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Application_Status] (
    [Application_Status_Id] BIGINT       IDENTITY (1, 1) NOT NULL,
    [Candidate_Id]          BIGINT       NULL,
    [Status]                VARCHAR (50) NULL,
    CONSTRAINT [PK_Tbl_Application_Status] PRIMARY KEY CLUSTERED ([Application_Status_Id] ASC)
)





END

