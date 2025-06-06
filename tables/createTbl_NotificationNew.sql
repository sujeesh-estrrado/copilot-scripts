-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_NotificationNew]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_NotificationNew](
	[Notification_id] [bigint] IDENTITY(1,1) NOT NULL,
	[Notification_msg] [varchar](max) NULL,
	[Notification_date] [datetime] NULL,
	[Notification_url] [varchar](max) NULL,
	[IsRead_Status] [bit] NULL,
	[Category] [varchar](100) NULL,
	[Sented_by] [bigint] NULL,
	[User_Id] [bigint] NULL,
	[Category_id] [bigint] NULL,
	[Organisation_id] [bigint] NULL,
	[Emp_Id] [bigint] NULL,
CONSTRAINT [PK_Tbl_NotificationNew] PRIMARY KEY CLUSTERED 
(
	[Notification_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

