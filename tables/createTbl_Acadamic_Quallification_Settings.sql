-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Acadamic_Quallification_Settings]') AND type = N'U')
BEGIN
	CREATE TABLE [dbo].[Tbl_Acadamic_Quallification_Settings](
	[Acadamic_settings_id] [bigint] IDENTITY(1,1) NOT NULL,
	[Course_level_id] [bigint] NULL,
	[Secondary_Status] [bit] NULL,
	[Higher_Secondary_Status] [bit] NULL,
	[Additional_Qualification_Status] [bit] NULL,
	[delete_status] [bit] NULL,
	[created_date] [datetime] NULL,
	 CONSTRAINT [PK_Tbl_Acadamic_Quallification_Settings] PRIMARY KEY CLUSTERED 
(
	[Acadamic_settings_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

