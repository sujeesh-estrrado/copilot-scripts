-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Refund_Request_Details]') AND type = N'U')
BEGIN
	CREATE TABLE [dbo].[Refund_Request_Details](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ApprovalRequestId] [bigint] NULL,
	[transactionid] [bigint] NULL,
	[Amount] [decimal](18, 2) NULL,
	[Remarks] [varchar](500) NULL,
	[Ledger] [char](10) NULL,
	CONSTRAINT [PK_Refund_Request_Details] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

