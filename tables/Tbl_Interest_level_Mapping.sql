-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Interest_level_Mapping]') AND type = N'U')
BEGIN
CREATE TABLE [dbo].[Tbl_Interest_level_Mapping](
	[Lead_Status_Id] [bigint] NOT NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [bigint] NULL,
	[InterestLevel_ID] [int] NULL,
	[Interest_Level_Mp_ID] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]
END

