-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Budget_Approvals]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Budget_Approvals](
	[Event_Id] [bigint] NULL,
	[MarketingManagerApproval] [bigint] NULL,
	[MarketingManagerApproval_Remark] [varchar](max) NULL,
	[MarketingManagerReject_Remark] [varchar](max) NULL,
	[PsoApproval] [bigint] NULL,
	[PsoApproval_Remark] [varchar](max) NULL,
	[PsoReject_Remark] [varchar](max) NULL,
	[DirectorApproval] [bigint] NULL,
	[DirectorApproval_Remark] [varchar](max) NULL,
	[DirectorReject_Remark] [varchar](max) NULL,
	[MD_Approval] [bigint] NULL,
	[MD_ApprovalRemark] [varchar](max) NULL,
	[MD_RejectRemark] [varchar](max) NULL
	
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

