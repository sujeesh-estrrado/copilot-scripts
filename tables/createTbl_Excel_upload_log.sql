-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Excel_upload_log]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Excel_upload_log](
	[Log_id] [bigint] IDENTITY(1,1) NOT NULL,
	[Excel_name] [varchar](max) NULL,
	[Upload_date] [datetime] NULL,
	[delete_status] [bit] NULL,
	[Uploaded_by] [bigint] NOT NULL,
	[Source] [varchar](max) NULL,
	[source_name] [varchar](max) NULL,
	[total_count] [bigint] NULL,
CONSTRAINT [PK_Tbl_Excel_upload_log] PRIMARY KEY CLUSTERED 
(
	[Log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

