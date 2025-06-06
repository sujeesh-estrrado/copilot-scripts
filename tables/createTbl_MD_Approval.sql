-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_MD_Approval]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_MD_Approval](
	[Event_Id] [bigint] NULL,
	[Approval_Status] [bigint] NULL,
	[Approval_Remark] [varchar](max) NULL,
	[Reject_Remark] [varchar](max) NULL

) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

