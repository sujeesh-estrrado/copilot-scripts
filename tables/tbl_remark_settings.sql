-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_remark_settings]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[tbl_remark_settings](
	[Remark_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Remark_Name] [varchar](50) NOT NULL,
	[Status] [bigint] NOT NULL,
  CONSTRAINT [PK_Tbl_Remark_Settings] PRIMARY KEY CLUSTERED 
(
	[Remark_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

