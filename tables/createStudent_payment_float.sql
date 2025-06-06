-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[student_payment_float]') AND type = N'U')
BEGIN
	CREATE TABLE [dbo].[student_payment_float](
	[paymentfloatid] [bigint] IDENTITY(1,1) NOT NULL,
	[studentid] [bigint] NULL,
	[floatamount] [decimal](18, 2) NULL,
	[flagLedger] [varchar](50) NULL,
	[accountcodeid] [bigint] NULL,
	CONSTRAINT [PK_student_payment_float] PRIMARY KEY CLUSTERED 
(
	[paymentfloatid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

