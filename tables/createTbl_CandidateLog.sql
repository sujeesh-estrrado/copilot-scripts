-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_CandidateLog]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_CandidateLog](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[CandidateID] [bigint] NULL,
	[LogMsg] [varchar](max) NULL,
	[Date] [datetime] NULL,
	[DelStatus] [bit] NULL,
 CONSTRAINT [PK_Tbl_CandidateLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

