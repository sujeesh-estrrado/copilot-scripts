-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Pso_Approval]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Pso_Approval](
	[Pso_Approval_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Event_ID] [bigint] NULL,
	[Approval_Status] [bigint] NULL,
	[Approval_Remark] [varchar](max) NULL,
	[Reject_Remark] [varchar](max) NULL,
 CONSTRAINT [PK_Tbl_PsoApproval] PRIMARY KEY CLUSTERED 
(
	[Pso_Approval_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

