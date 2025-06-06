-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_ProgramCertificateSettings]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_ProgramCertificateSettings](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[Student_type] [varchar](50) NULL,
	[Department_id] [bigint] NULL,
	[English_Test_Status] [bit] NULL,
	[Work_Experience_status] [bit] NULL,
	[Research_status] [bit] NULL,
	[Annual_practice] [bit] NULL,
	[Createdate] [datetime] NULL,
	[Delete_status] [bit] NULL,
 CONSTRAINT [PK_Tbl_Candidate_Other_settings] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

