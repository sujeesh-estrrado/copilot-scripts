-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Candidate_Additionalqualification]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Candidate_Additionalqualification](
	[Qualification_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Candidate_Id] [bigint] NULL,
	[QualificationLevel] [varchar](max) NULL,
	[Qualification] [varchar](max) NULL,
	[InstitutionName] [varchar](max) NULL,
	[YearofPass] [varchar](max) NULL,
	[Result] [varchar](max) NULL,
	[ResultAttachment] [varchar](max) NULL,
	[Created_Date] [datetime] NULL,
	[Updated_date] [datetime] NULL,
	[Delete_Status] [bit] NULL,
	CONSTRAINT [PK_Tbl_Candidate_Additionalqualification] PRIMARY KEY CLUSTERED 
	(
	[Qualification_Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

