-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_FollowUpStatus]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_FollowUpStatus](
	[Status_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Status] [varchar](max) NULL,
	[Del_Status] [bigint] NULL

) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

