-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Department_Subjects]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Department_Subjects](
	[Department_Subject_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Course_Department_Id] [bigint] NULL,
	[Subject_Id] [bigint] NULL,
	[Syllabus_Year] [varchar](50) NULL,
	[Department_Subject_Status] [bit] NULL,
 CONSTRAINT [PK_Tbl_Department_Subjects_1] PRIMARY KEY CLUSTERED 
(
	[Department_Subject_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

