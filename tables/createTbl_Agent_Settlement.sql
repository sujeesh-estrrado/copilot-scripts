-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Agent_Settlement]') AND type = N'U')
BEGIN
	CREATE TABLE [dbo].[Tbl_Agent_Settlement](
	[receiptid] [bigint] IDENTITY(1,1) NOT NULL,
	[Amount] [decimal](18, 2) NULL,
	[paymentmethod] [bigint] NULL,
	[remarks] [varchar](max) NULL,
	[Invoice_Id] [bigint] NULL,
	[cashierid] [bigint] NULL,
	[studentid] [bigint] NULL,
	[AgentId] [bigint] NULL,
	[dateissued] [datetime] NULL,
	[bankname] [varchar](max) NULL,
	[refno] [varchar](max) NULL,
	[checkdate] [datetime] NULL,
	[Attachement_Path] [varchar](max) NULL,
	[Created_Date] [datetime] NULL,
	[Updated_Date] [datetime] NULL,
	[Delete_Status] [bit] NULL,
	[Payee_id] [bigint] NULL,
 CONSTRAINT [PK_Tbl_Agent_Settlement] PRIMARY KEY CLUSTERED 
(
	[receiptid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

