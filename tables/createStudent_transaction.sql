-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[student_transaction]') AND type = N'U')
BEGIN
	CREATE TABLE [dbo].[student_transaction](
	[transactionid] [bigint] IDENTITY(1,1) NOT NULL,
	[accountcodeid] [bigint] NULL,
	[docno] [varchar](20) NULL,
	[description] [varchar](255) NULL,
	[amount] [decimal](18, 2) NULL,
	[balance] [decimal](18, 2) NULL,
	[paymentmethod] [bigint] NULL,
	[transactiontype] [bigint] NULL,
	[remarks] [varchar](255) NULL,
	[datetimeissued] [datetime] NULL,
	[dateissued] [datetime] NULL,
	[refdocno] [varchar](20) NULL,
	[refdocdate] [datetime] NULL,
	[cashierid] [bigint] NULL,
	[studentid] [bigint] NULL,
	[courseid] [bigint] NULL,
	[semesterno] [bigint] NULL,
	[intakeid] [bigint] NULL,
	[semesterid] [bigint] NULL,
	[billid] [bigint] NULL,
	[billgroupid] [bigint] NULL,
	[relatedid] [bigint] NULL,
	[adjustedid] [bigint] NULL,
	[adjustmentamount] [float] NULL,
	[canadjust] [bigint] NULL,
	[thirdpartyid] [bigint] NULL,
	[printcount] [bigint] NULL,
	[billcancel] [bigint] NULL,
	[flagledger] [char](2) NULL,
	[Status] [bigint] NULL,
	CONSTRAINT [PK__student___9B52C2FAF237F0E3] PRIMARY KEY CLUSTERED 
(
	[transactionid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

