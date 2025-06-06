-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_SponsorshipSemDetails]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[tbl_SponsorshipSemDetails](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[SponsorshipID] [bigint] NULL,
	[SemID] [bigint] NULL,
	[PerSemAmount] [decimal](18, 2) NULL,
	[DeleteStatus] [bit] NULL,
  CONSTRAINT [PK_tbl_SponsorshipSemDetails] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

