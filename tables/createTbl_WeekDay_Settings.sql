-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_WeekDay_Settings]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_WeekDay_Settings](
	[WeekDay_Settings_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[WeekDay_Name] [varchar](100) NOT NULL,
	[WeekDay_Code] [varchar](50) NOT NULL,
	[WeekDay_Status] [bit] NOT NULL,
	[WeekDay_Batch_Mapping_Id] [bigint] NULL,
 CONSTRAINT [PK_Tbl_WeekDay_Settings] PRIMARY KEY CLUSTERED 
(
	[WeekDay_Settings_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_WeekDay_Settings]') AND type = N'U')
BEGIN
    IF NOT EXISTS (SELECT 1 FROM [dbo].[Tbl_WeekDay_Settings])
    BEGIN
        INSERT INTO [dbo].[Tbl_WeekDay_Settings] (
            [WeekDay_Name], [WeekDay_Code], [WeekDay_Status], [WeekDay_Batch_Mapping_Id]
        )
        VALUES 
            ('Monday', 'MON', 1, NULL),
            ('Tuesday', 'TUE', 1, NULL),
            ('Wednesday', 'WED', 1, NULL),
            ('Thursday', 'THU', 1, NULL),
            ('Friday', 'FRI', 1, NULL),
            ('Saturday', 'SAT', 1, NULL),
            ('Sunday', 'SUN', 1, NULL)
    END
END
