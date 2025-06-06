-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_AutoInvoiceLog]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_AutoInvoiceLog](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[StudentId] [bigint] NULL,
	[Feegroupid] [bigint] NULL,
	[Semester] [int] NULL,
	[InvoiceDate] [datetime] NULL,
	[Billid] [bigint] NULL,
	[BillGroupID] [bigint] NULL,
	[TransactionID] [bigint] NULL,
	 CONSTRAINT [PK_Tbl_AutoInvoiceLog] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

