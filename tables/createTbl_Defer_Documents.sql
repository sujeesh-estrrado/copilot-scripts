-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Defer_Documents]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Defer_Documents](
	[Doc_id] [bigint] IDENTITY(1,1) NOT NULL,
	[Defer_Request_id] [bigint] NULL,
	[Candidate_id] [bigint] NULL,
	[Docname] [varchar](max) NULL,
	[Path] [varchar](max) NULL,
	[create_date] [datetime] NULL,
	[delete_status] [bit] NULL,
 CONSTRAINT [PK_Tbl_Defer_Documents] PRIMARY KEY CLUSTERED 
(
	[Doc_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

