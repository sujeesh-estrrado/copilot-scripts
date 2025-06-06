-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Sponsorship_candidate_mapping]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Sponsorship_candidate_mapping](
	[Sponsorship_Mapping_id] [bigint] IDENTITY(1,1) NOT NULL,
	[candidate_id] [bigint] NULL,
	[Sponsorship_Name] [varchar](max) NULL,
	[Createdate] [datetime] NULL,
	[delete_status] [bit] NULL,
 CONSTRAINT [PK_Tbl_Sponsorship_candidate_mapping] PRIMARY KEY CLUSTERED 
(
	[Sponsorship_Mapping_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

