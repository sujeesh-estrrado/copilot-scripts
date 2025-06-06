-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Marketing_ManangerApproval]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Marketing_ManangerApproval](
	[Marketing_ManagerApproval_ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Event_Id] [bigint] NULL,
	[Approval_Status] [bigint] NULL,
	[Approval_Remark] [varchar](max) NULL,
	[Reject_Remark] [varchar](max) NULL,
 CONSTRAINT [PK_Tbl_Marketing_ManangerApproval] PRIMARY KEY CLUSTERED 
(
	[Marketing_ManagerApproval_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

