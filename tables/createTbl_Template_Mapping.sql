-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Template_Mapping]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Template_Mapping](
	[Template_mapping_id] [bigint] IDENTITY(1,1) NOT NULL,
	[Template_id] [bigint] NULL,
	[Category] [varchar](max) NULL,
	[Create_date] [varchar](50) NULL,
	[Update_date] [varchar](50) NULL,
	[delete_status] [bit] NULL,
CONSTRAINT [PK_Tbl_Template_Mapping] PRIMARY KEY CLUSTERED 
(
	[Template_mapping_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

