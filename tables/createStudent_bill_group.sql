-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[student_bill_group]') AND type = N'U')
BEGIN
	CREATE TABLE [dbo].[student_bill_group](
	[billgroupid] [bigint] IDENTITY(1,1) NOT NULL,
	[docno] [varchar](50) NULL,
	[studentid] [bigint] NOT NULL,
	[totalamount] [decimal](18, 2) NULL,
	[dateissued] [datetime] NULL,
	[datedue] [datetime] NULL,
	[printcount] [bigint] NULL,
	[flagledger] [char](10) NULL,
	[datecreated] [datetime] NULL,
	[createdby] [bigint] NULL,
	[updatedby] [bigint] NULL,
	[updateon] [datetime] NULL,
	[delstatus] [bit] NOT NULL,
	CONSTRAINT [PK_student_bill_group] PRIMARY KEY CLUSTERED 
(
	[billgroupid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

