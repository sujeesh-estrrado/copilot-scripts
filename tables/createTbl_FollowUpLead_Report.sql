-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_FollowUpLead_Report]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_FollowUpLead_Report](
	[SlNo] [int] NULL,
	[Counselor_Employee] [varchar](100) NULL,
	[TotalLeads] [int] NULL,
	[Future] [int] NULL,
	[KIV] [int] NULL,
	[LetGo] [int] NULL,
	[NextIntake] [int] NULL

) ON [PRIMARY]
END

