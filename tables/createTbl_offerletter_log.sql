-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_offerletter_log]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_offerletter_log](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NULL,
	[tempname] [varchar](255) NULL,
	[temppath] [varchar](255) NULL,
	[senddate] [datetime] NULL,
	[sendby] [varchar](100) NULL,
	[template_id] [varchar](10) NULL,
	[offeracceptstatus] [varchar](10) NULL,
	[acceptdate] [date] NULL,
	[status] [varchar](25) NULL,
	[Offer_letter_Skipped_Date] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

