-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_WeekDay_Batch_Mapping]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_WeekDay_Batch_Mapping](
	[WeekDay_Batch_Mapping_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Course_Department_Id] [bigint] NOT NULL,
	[Duration_Mapping_Id] [bigint] NOT NULL,
	[WeekDay_Settings_Id] [bigint] NOT NULL,
	[WeekDay_Status] [bit] NULL,
CONSTRAINT [PK_Tbl_WeekDay_Settings_New] PRIMARY KEY CLUSTERED 
(
	[WeekDay_Batch_Mapping_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

