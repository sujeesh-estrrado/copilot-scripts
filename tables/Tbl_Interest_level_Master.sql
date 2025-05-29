-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Interest_level_Master]') AND type = N'U')
BEGIN
CREATE TABLE [dbo].[Tbl_Interest_level_Master](
	[Interest_level_Name] [varchar](50) NOT NULL,
	[Interest_level_DelStatus] [bit] NOT NULL,
	[Interest_level_CreatedBy] [bigint] NULL,
	[Interest_level_CreatedDate] [datetime] NULL,
	[Interest_level_UpdateBy] [bigint] NULL,
	[Ineterest_level_UpdatedDate] [datetime] NULL,
	[Interest_level_DelDate] [datetime] NULL,
	[InterestLevel_ID] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]
END

