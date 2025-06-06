-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Agent_Invoice]') AND type = N'U')
BEGIN
	CREATE TABLE [dbo].[Tbl_Agent_Invoice](
	[AgenInvoiceId] [bigint] IDENTITY(1,1) NOT NULL,
	[Invoiceno] [varchar](max) NULL,
	[Agent_Id] [bigint] NULL,
	[Candidate_Id] [bigint] NULL,
	[Invoice_Date] [datetime] NULL,
	[Upload] [varchar](max) NULL,
	[Remarks] [varchar](max) NULL,
	[Approval_status] [bit] NULL,
	[Approved_By] [bigint] NULL,
	[Approved_date] [datetime] NULL,
	[Amount_Paid] [decimal](18, 2) NULL,
	[Delete_Status] [bit] NULL,
	[Created_Date] [datetime] NULL,
	[Updated_Date] [datetime] NULL,
 CONSTRAINT [PK_Tbl_Agent_Invoice] PRIMARY KEY CLUSTERED 
(
	[AgenInvoiceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

