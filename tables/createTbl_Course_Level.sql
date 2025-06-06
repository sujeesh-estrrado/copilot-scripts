-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Course_Level]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Course_Level](
	[Course_Level_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Course_Level_Name] [varchar](300) NULL,
	[Course_Level_Descripition] [varchar](500) NULL,
	[facultycode] [varchar](500) NULL,
	[Faculty_dean_id] [bigint] NULL,
	[odr] [varchar](50) NULL,
	[Course_Level_Date] [varchar](50) NULL,
	[Course_Level_Status] [bit] NULL,
	[Update_Date] [datetime] NULL,
	[Delete_Status] [bit] NULL,
 CONSTRAINT [PK_Tbl_Course_Level] PRIMARY KEY CLUSTERED 
(
	[Course_Level_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
    ALTER TABLE [dbo].[Tbl_Course_Level] ADD  CONSTRAINT [DF_Tbl_Course_Level_Course_Level_Status]  DEFAULT ((0)) FOR [Course_Level_Status]

END

