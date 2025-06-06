-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Candidate_NopassportList]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Candidate_NopassportList](
	[PassportId] [bigint] IDENTITY(1,1) NOT NULL,
	[Candidate_id] [bigint] NULL,
	[PassportNo] [varchar](max) NULL,
	[Created_date] [datetime] NULL,
	[Updated_date] [datetime] NULL,
	[Delete_status] [bit] NULL,
 CONSTRAINT [PK_Tbl_Candidate_NopassportList] PRIMARY KEY CLUSTERED 
(
	[PassportId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

