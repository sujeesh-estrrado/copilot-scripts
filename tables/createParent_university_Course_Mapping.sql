-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Parent_university_Course_Mapping]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Parent_university_Course_Mapping](
	[CoursePM_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Course_id] [bigint] NULL,
	[Parent_university_Id] [bigint] NULL,
	[Parent_university_Grade] [bigint] NULL,
	[Parent_university_ResitGrade] [bigint] NULL,
	[delete_status] [bit] NULL,
	[AssessmentCode] [bigint] NULL,
	CONSTRAINT [PK_Parent_university_Course_Mapping] PRIMARY KEY CLUSTERED 
	(
	[CoursePM_Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
END

