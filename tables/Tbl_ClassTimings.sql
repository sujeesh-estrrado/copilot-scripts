-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_ClassTimings]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_ClassTimings](
	[Class_Timings_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Hour_Name] [varchar](150) NOT NULL,
	[Start_Time] [datetime] NOT NULL,
	[End_Time] [datetime] NOT NULL,
	[Is_BreakTime] [bit] NOT NULL,
	[ClassTiming_Status] [bit] NOT NULL,
	[Course_Department_Id] [bigint] NULL,
	[Duration_Mapping_Id] [bigint] NULL,
 CONSTRAINT [PK_Tbl_ClassTimings] PRIMARY KEY CLUSTERED 
(
	[Class_Timings_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

