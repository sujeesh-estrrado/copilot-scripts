-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[student_payment]') AND type = N'U')
BEGIN
	CREATE TABLE [dbo].[student_payment](
	[receiptid] [bigint] IDENTITY(1,1) NOT NULL,
	[receiptnumber] [varchar](100) NULL,
	[accountcodeid] [bigint] NULL,
	[description] [varchar](255) NULL,
	[amount] [decimal](18, 2) NULL,
	[payment] [decimal](18, 2) NULL,
	[balance] [decimal](18, 2) NULL,
	[paymentmethod] [bigint] NULL,
	[remarks] [varchar](255) NULL,
	[datetimeissued] [datetime] NULL,
	[cashierid] [bigint] NULL,
	[studentid] [bigint] NULL,
	[transactionid] [bigint] NULL,
	[billid] [bigint] NULL,
	[dateissued] [datetime] NULL,
	[bankname] [varchar](100) NULL,
	[refno] [varchar](30) NULL,
	[checkdate] [datetime] NULL,
	[adjustmentamount] [decimal](18, 2) NOT NULL,
	[canadjust] [bigint] NULL,
	[flagledger] [char](2) NULL,
	CONSTRAINT [PK_student_payment] PRIMARY KEY CLUSTERED 
(
	[receiptid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

