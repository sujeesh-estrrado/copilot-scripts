-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Student_Semester]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Student_Semester](
	[Student_Semester_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Candidate_Id] [bigint] NULL,
	[Duration_Mapping_Id] [bigint] NULL,
	[Student_Semester_Current_Status] [bit] NULL,
	[Student_Semester_Delete_Status] [bit] NULL,
	[IC_PASSPORT] [nvarchar](50) NULL,
	[COURSE_CODE] [nvarchar](50) NULL,
	[INTAKE_NUMBER] [nvarchar](50) NULL,
	[STUDY_MODE] [nvarchar](50) NULL,
	[SEMESTER_NO] [nvarchar](50) NULL,
	[BatchId] [bigint] NULL,
	[SemesterId] [bigint] NULL,
	[FromDate] [datetime] NULL,
	[ToDate] [datetime] NULL,
	[Duration_Period_Id] [bigint] NULL,
	[PromoteFrom_Date] [datetime] NULL,
	[PromoteTo_Date] [datetime] NULL,
	[Old_SemesterName] [varchar](100) NULL,
	[Created_Date] [datetime] NULL,
	[Updated_Date] [datetime] NULL,
	[Delete_Status] [bit] NULL,
  CONSTRAINT [PK_Tbl_Student_Semester] PRIMARY KEY CLUSTERED 
(
	[Student_Semester_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

