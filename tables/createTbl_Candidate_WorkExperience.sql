-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Candidate_WorkExperience]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Candidate_WorkExperience](
	[WorkExp_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Candidate_Id] [bigint] NULL,
	[Employer] [varchar](max) NULL,
	[Position] [varchar](max) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[ExperienceCertificate] [varchar](max) NULL,
	[Created_date] [datetime] NULL,
	[Updated_date] [datetime] NULL,
	[Delete_Status] [bit] NULL,
CONSTRAINT [PK_Tbl_Candidate_WorkExperience] PRIMARY KEY CLUSTERED 
(
	[WorkExp_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

