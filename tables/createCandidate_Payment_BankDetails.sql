-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Candidate_Payment_BankDetails]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Candidate_Payment_BankDetails](
		[Id] [bigint] IDENTITY(1,1) NOT NULL,
		[ApprovalRequestId] [bigint] NULL,
		[paymentmethod] [bigint] NULL,
		[Remark] [varchar](500) NULL,
		[bankname] [bigint] NULL,
		[refno] [varchar](50) NULL,
		[refdocdate] [date] NULL,
		[Attachmenturl] [varchar](max) NULL,
		[Ledger] [char](10) NULL,
		CONSTRAINT [PK_Candidate_Payment_BankDetails] PRIMARY KEY CLUSTERED 
		(
		[Id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

