-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Report_Log]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Report_Log](
	[Report_LogId] [bigint] IDENTITY(1,1) NOT NULL,
	[Employee_Id] [bigint] NULL,
	[Report_Url] [varchar](max) NULL,
	[Report_Name] [varchar](max) NULL,
	[Generate_Time] [datetime] NULL,
CONSTRAINT [PK_Tbl_Report_Log] PRIMARY KEY CLUSTERED 
(
	[Report_LogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

