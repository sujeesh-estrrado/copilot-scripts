-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_New_Course]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_New_Course](
	[Course_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Org_Id] [bigint] NULL,
	[Faculty_Id] [bigint] NULL,
	[courseid] [bigint] NULL,
	[Course_Name] [varchar](max) NULL,
	[Course_code] [varchar](max) NULL,
	[Course_credit] [varchar](max) NULL,
	[ContactHours] [bigint] NULL,
	[SubjectTotalHours] [bigint] NULL,
	[Course_GPS] [varchar](100) NULL,
	[Grade_Id] [bigint] NULL,
	[Course_Type] [varchar](100) NULL,
	[Course_Prequisite] [bigint] NULL,
	[AssessmentCode] [bigint] NULL,
	[Minimum_Students] [bigint] NULL,
	[Active_Status] [varchar](max) NULL,
	[Created_Date] [datetime] NULL,
	[Updated_Date] [datetime] NULL,
	[Delete_Status] [bit] NULL,
	[ResitGrade] [bigint] NULL,
 CONSTRAINT [PK_Tbl_New_Course] PRIMARY KEY CLUSTERED 
(
	[Course_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

