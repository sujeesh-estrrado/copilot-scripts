-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_User_notification_mapping]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_User_notification_mapping](
	[User_Notification_Map_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[RoleId] [bigint] NULL,
	[GoTo_Url] [varchar](max) NULL,
	[UserId] [bigint] NULL,
	[NotificationId] [bigint] NULL,
	[ReadUnreadStatus] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
	[Message_Sent_Status] [bit] NULL,
 CONSTRAINT [PK_Tbl_User_notification_mapping] PRIMARY KEY CLUSTERED 
(
	[User_Notification_Map_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

