-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Eligibilty_letter]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Eligibilty_letter](
	[Elgibility_id] [bigint] NULL,
	[Candidate_id] [bigint] NULL,
	[Letter_path] [varchar](max) NULL,
	[Created_by] [bigint] NULL,
	[Create_date] [datetime] NULL,
	[Delete_status] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

