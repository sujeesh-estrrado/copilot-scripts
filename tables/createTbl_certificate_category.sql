-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_certificate_category]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[tbl_certificate_category](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[category] [varchar](max) NULL,
	[delete_status] [bit] NULL,
	[create_date] [datetime] NULL,
	[update_date] [datetime] NULL,
CONSTRAINT [PK_tbl_certificate_category] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

