-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Course_Semester]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Course_Semester](
	[Semester_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Semester_Code] [varchar](50) NULL,
	[Semester_Name] [varchar](200) NULL,
	[Semester_DelStatus] [bit] NULL,
	[AcademicYear] [varchar](50) NULL,
  CONSTRAINT [PK_Tbl_Course_Semester] PRIMARY KEY CLUSTERED 
(
	[Semester_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
    ALTER TABLE [dbo].[Tbl_Course_Semester] ADD  CONSTRAINT [DF_Tbl_Course_Semester_Semester_DelStatus]  DEFAULT ((0)) FOR [Semester_DelStatus]
END

