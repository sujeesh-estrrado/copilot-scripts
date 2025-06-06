-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Student_InvoiceUpload]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Student_InvoiceUpload](
		[id] [bigint] IDENTITY(1,1) NOT NULL,
	[StudentId] [bigint] NULL,
	[InvoiceDescription] [varchar](500) NULL,
	[DocumentLoc] [varchar](max) NULL,
	[DocType] [bigint] NULL,
	[CreatedDate] [date] NULL,
	[LastUpdate] [date] NULL,
	[DeleteStatus] [bit] NULL,
	[PaymentLinK] [varchar](500) NULL,
	[IsModular] [int] NOT NULL,
		PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

