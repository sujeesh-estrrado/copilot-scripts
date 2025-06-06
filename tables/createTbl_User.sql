-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_User]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_User](
	[user_Id] [bigint] NOT NULL,
	[role_Id] [int] NOT NULL,
	[user_name] [varchar](100) NULL,
	[user_password] [varchar](50) NULL,
	[user_Status] [bit] NULL,
	[user_DeleteStatus] [bit] NULL,
	[user_Email] [varchar](50) NULL,
	[Lms_userid] [int] NULL
) ON [PRIMARY]
END

-- Insert data only if the table exists and is empty
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_User]') AND type = N'U')
BEGIN
    IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_User])
    BEGIN
        INSERT INTO [dbo].[tbl_User] ([user_Id],[role_Id], [user_name],[user_password], [user_Status], [user_DeleteStatus], [user_Email], [Lms_userid]) 
        VALUES 
        (1, 1, N'admin', N'40BD001563085FC35165329EA1FF5C5ECBDBBEEF', null,null, N'admin@admin.com', null)
    END
END