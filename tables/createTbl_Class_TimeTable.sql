-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Class_TimeTable]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Class_TimeTable](
	[Class_TimeTable_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Semster_Subject_Id] [bigint] NOT NULL,
	[Duration_Mapping_Id] [bigint] NOT NULL,
	[WeekDay_Settings_Id] [bigint] NOT NULL,
	[Class_Timings_Id] [bigint] NOT NULL,
	[Employee_Id] [bigint] NOT NULL,
	[Class_TimeTable_Status] [bit] NOT NULL,
	[Day_Id] [bigint] NULL,
	[Location_Id] [bigint] NULL,
	[Department_Id] [int] NOT NULL,
	[Del_Status] [int] NULL,
CONSTRAINT [PK_Tbl_Class_TimeTable] PRIMARY KEY CLUSTERED 
(
	[Class_TimeTable_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END