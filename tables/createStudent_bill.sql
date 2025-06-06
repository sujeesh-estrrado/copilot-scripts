-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[student_bill]') AND type = N'U')
BEGIN
	CREATE TABLE [dbo].[student_bill](
	[billid] [bigint] IDENTITY(1,1) NOT NULL,
	[accountcodeid] [bigint] NULL,
	[docno] [varchar](20) NULL,
	[description] [varchar](255) NULL,
	[studentid] [bigint] NULL,
	[totalamountpayable] [decimal](18, 2) NOT NULL,
	[totalamountpaid] [decimal](18, 2) NOT NULL,
	[outstandingbalance] [decimal](18, 2) NOT NULL,
	[billgroupid] [bigint] NULL,
	[dateissue] [datetime] NULL,
	[datedue] [datetime] NULL,
	[datecreated] [datetime] NULL,
	[createdby] [bigint] NULL,
	[dateupdated] [datetime] NULL,
	[updatedby] [bigint] NULL,
	[adjustmentamount] [decimal](18, 2) NOT NULL,
	[canadjust] [bigint] NULL,
	[billcancel] [bigint] NULL,
	[flagledger] [char](10) NULL,
	CONSTRAINT [PK_student_bill] PRIMARY KEY CLUSTERED 
(
	[billid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

