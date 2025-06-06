-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Agent_AdvancePayment]') AND type = N'U')
BEGIN
	CREATE TABLE [dbo].[Tbl_Agent_AdvancePayment](
	[AdvanceId] [bigint] IDENTITY(1,1) NOT NULL,
	[Agent_Id] [bigint] NULL,
	[Requested_Amount] [decimal](18, 2) NULL,
	[Agent_Remarks] [varchar](max) NULL,
	[Approved_Amount] [decimal](18, 2) NULL,
	[Approval_Status] [bigint] NULL,
	[Approval_Remarks] [varchar](max) NULL,
	[Approved_By] [varchar](max) NULL,
	[created_Date] [datetime] NULL,
	[Updated_Date] [datetime] NULL,
	[Delete_Status] [bit] NULL,
	[Rejection_Remarks] [varchar](max) NULL,
 CONSTRAINT [PK_Tbl_Agent_AdvancePayment] PRIMARY KEY CLUSTERED 
(
	[AdvanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

