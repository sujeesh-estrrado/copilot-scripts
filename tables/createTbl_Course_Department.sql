-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Course_Department]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Course_Department](
	[Course_Department_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Department_Id] [bigint] NULL,
	[Course_Category_Id] [bigint] NULL,
	[Course_Department_Description] [varchar](500) NULL,
	[Course_Department_Date] [varchar](50) NULL,
	[Course_Department_Status] [bit] NULL,
	[Course_Department_Code] [varchar](50) NULL,
	[ProviderId] [bigint] NULL,
 CONSTRAINT [PK_Tbl_Course_Department] PRIMARY KEY CLUSTERED 
(
	[Course_Department_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [dbo].[Tbl_Course_Department] ADD  CONSTRAINT [DF_Course_Department_Course_Department_Status]  DEFAULT ((0)) FOR [Course_Department_Status]

END

