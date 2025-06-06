-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Day_Week]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Day_Week](
	[Day_Week_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Dept_Id] [bigint] NOT NULL,
	[Day_Week_Status] [varchar](50) NOT NULL,
	[Day_Id] [bigint] NULL,
	[WeekDay_Settings_Id] [bigint] NULL,
	[Checked_Status] [bit] NOT NULL,
	[Status] [bit] NOT NULL,
	[Created_Date] [datetime] NULL,
	[Updated_Date] [datetime] NULL,
	[Location_Id] [bigint] NULL,
 CONSTRAINT [PK_Tbl_Day_Week] PRIMARY KEY CLUSTERED 
(
	[Day_Week_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

