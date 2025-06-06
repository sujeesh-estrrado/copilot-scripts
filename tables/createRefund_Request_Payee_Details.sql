-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Refund_Request_Payee_Details]') AND type = N'U')
BEGIN
	CREATE TABLE [dbo].[Refund_Request_Payee_Details](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ApprovalRequestId] [bigint] NULL,
	[StudentID] [bigint] NULL,
	[PaymentRegion] [int] NULL,
	[PayMethod] [int] NULL,
	[StudentName] [varchar](max) NULL,
	[AccountNumber] [varchar](max) NULL,
	[BankName] [varchar](max) NULL,
	[BankAddress] [varchar](max) NULL,
	[BankCity] [varchar](max) NULL,
	[BankCountry] [varchar](max) NULL,
	[BankCode] [varchar](max) NULL,
	[Status] [int] NULL,
	[CreateDate] [date] NULL,
	[UpdateDate] [date] NULL,
	CONSTRAINT [PK_Refund_Request_Payee_Details] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

