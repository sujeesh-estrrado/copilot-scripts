-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_approval_log]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[tbl_approval_log](
	[approval_id] [bigint] IDENTITY(1,1) NOT NULL,
	[candidate_id] [bigint] NULL,
	[Approved_by] [bigint] NULL,
	[Approved_date] [datetime] NULL,
	[Verified_by] [bigint] NULL,
	[Verified_date] [datetime] NULL,
	[Interview_status] [varchar](50) NULL,
	[Interview_reshedule] [bigint] NULL,
	[Created_date] [datetime] NULL,
	[Updated_date] [datetime] NULL,
	[Offerletter_sent] [bit] NULL,
	[Offerletter_status] [bit] NULL,
	[offer_letter_accept_date] [datetime] NULL,
	[delete_status] [bit] NULL,
	[Skipped_date] [datetime] NULL,
	[Offer_letter_Skip_Status] [int] NULL,
	CONSTRAINT [PK_tbl_approval_admission] PRIMARY KEY CLUSTERED 
	(
	[approval_id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
END

