-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Candidate_Education_Grade]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Candidate_Education_Grade](
	[Edu_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Sub_Name] [varchar](max) NULL,
	[Sub_Grade] [varchar](max) NULL,
	[Education_Type] [varchar](max) NULL,
	[Cand_Id] [bigint] NULL,
	[Sub_other] [varchar](max) NULL,
	[Created_Date] [datetime] NULL,
	[Updated_Date] [datetime] NULL,
	[Delete_status] [bit] NULL,
	CONSTRAINT [PK_Tbl_Candidate_Education_Grade] PRIMARY KEY CLUSTERED 
	(
	[Edu_Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

