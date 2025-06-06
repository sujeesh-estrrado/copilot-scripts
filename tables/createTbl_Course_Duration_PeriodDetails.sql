-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Course_Duration_PeriodDetails]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Course_Duration_PeriodDetails](
	[Duration_Period_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Org_Id] [bigint] NULL,
	[Batch_Id] [bigint] NULL,
	[Semester_Id] [bigint] NULL,
	[Duration_Period_From] [datetime] NULL,
	[Duration_Period_To] [datetime] NULL,
	[Duration_Period_Status] [bit] NULL,
	[Closing_Date] [datetime] NULL,
	[Duration_Period_Active_Status] [bit] NULL,
	[Created_Date] [datetime] NULL,
	[Updated_Date] [datetime] NULL,
	[Delete_Status] [bit] NULL,
 CONSTRAINT [PK_Tbl_Course_Duration_PeriodDetails_2] PRIMARY KEY CLUSTERED 
(
	[Duration_Period_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

