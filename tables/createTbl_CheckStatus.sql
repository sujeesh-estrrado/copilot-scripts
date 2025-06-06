-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_CheckStatus]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_CheckStatus](
	[CheckId] [bigint] IDENTITY(1,1) NOT NULL,
	[Secondary_status] [bit] NULL,
	[HigherSecondary_status] [bit] NULL,
	[AdditionalCheck_status] [bit] NULL,
	[EnglishTest_status] [bit] NULL,
	[Candidate_Id] [bigint] NULL,
	[Created_date] [datetime] NULL,
	[Updated_date] [datetime] NULL,
	[Delete_status] [bit] NULL,
	[ButtonStatus] [varchar](max) NULL,
CONSTRAINT [PK_Tbl_CheckStatus] PRIMARY KEY CLUSTERED 
(
	[CheckId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

