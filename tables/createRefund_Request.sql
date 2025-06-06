-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Refund_Request]') AND type = N'U')
BEGIN
	CREATE TABLE [dbo].[Refund_Request](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ApprovalRequestId] [bigint] NULL,
	[Type] [bigint] NULL,
	[billId] [bigint] NULL,
	[receiptid] [bigint] NULL,
	[Amount] [decimal](18, 2) NULL,
	[Status] [bigint] NULL,
	[Remarks] [varchar](500) NULL,
	[Approved_Amount] [decimal](18, 2) NULL,
	CONSTRAINT [PK_Refund_Request] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

