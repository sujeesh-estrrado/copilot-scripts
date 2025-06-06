-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Course_Category]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Course_Category](
[Course_Category_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Course_level_Id] [bigint] NULL,
	[Course_Category_Name] [varchar](300) NULL,
	[Course_Category_Descripition] [varchar](500) NULL,
	[Course_Category_Date] [datetime] NULL,
	[Course_Category_Status] [bit] NULL,
	[Program_Code] [varchar](300) NULL,
	[Program_Email] [varchar](50) NULL,
	[Program_Director] [varchar](50) NULL,
	[Updated_Date] [datetime] NULL,
	[Delete_Status] [bit] NULL,
	[totalsemester] [varchar](50) NULL,
 CONSTRAINT [PK_Course_Category] PRIMARY KEY CLUSTERED 
(
	[Course_Category_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

    ALTER TABLE [dbo].[Tbl_Course_Category] ADD  CONSTRAINT [DF_Course_Category_Course_Category_Status]  DEFAULT ((0)) FOR [Course_Category_Status]

END

