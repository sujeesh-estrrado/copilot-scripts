-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Candidate_EducationDetails]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Candidate_EducationDetails](
	[Candidate_EducationDetails_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Candidate_Id] [bigint] NULL,
	[Exam_Name] [varchar](max) NULL,
	[Other_Level] [varchar](max) NULL,
	[Exam_Board] [varchar](max) NULL,
	[University_Board] [varchar](max) NULL,
	[Reg_No] [bigint] NULL,
	[Yearof_Pass] [bigint] NULL,
	[Institution_Name] [varchar](max) NULL,
	[Percentage] [float] NULL,
	[Edu_Details_DelStatus] [bit] NULL,
	[Institution_Level] [varchar](max) NULL,
	[Institution_Location] [varchar](max) NULL,
	[Result_Attachment_path] [varchar](max) NULL,
	[Qualification] [varchar](max) NULL,
	[Filepath] [varchar](max) NULL,
	[Created_Date] [datetime] NULL,
	[Updated_Date] [datetime] NULL,
	[Delete_Status] [bit] NULL,
	[Curriculum] [varchar](100) NULL,
	CONSTRAINT [PK_Tbl_Candidate_EducationDetails] PRIMARY KEY CLUSTERED 
	(
	[Candidate_EducationDetails_Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

