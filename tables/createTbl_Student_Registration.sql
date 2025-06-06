-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Student_Registration]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Student_Registration](
	[Student_Reg_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Candidate_Id] [bigint] NULL,
	[Course_Category_Id] [bigint] NULL,
	[Department_Id] [bigint] NULL,
	[Student_Serial_No] [varchar](200) NULL,
	[Student_Reg_No] [varchar](200) NULL,
	[Student_Reg_Status] [bit] NULL,
	[UserId] [bigint] NULL,
	[IC_PASSPORT] [nvarchar](50) NULL,
	[COURSE_CODE] [varchar](50) NULL,
	[STUDY_MODE] [nvarchar](50) NULL,
	[Tc_Status] [int] NULL,
	[Tc_Date] [datetime] NULL,
	[Tc_Remarks] [varchar](max) NULL,
	[Created_Date] [datetime] NULL,
	[Updated_date] [datetime] NULL,
	[Delete_Status] [bit] NULL,
 CONSTRAINT [PK_Tbl_Student_Registration] PRIMARY KEY CLUSTERED 
(
	[Student_Reg_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

