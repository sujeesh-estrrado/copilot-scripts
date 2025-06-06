-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Employee_User]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Employee_User](
	[Employee_User_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Employee_Id] [bigint] NULL,
	[User_Id] [int] NULL,
	[LMS_access] [varchar](5) NULL,
 CONSTRAINT [PK_Tbl_Employee_User] PRIMARY KEY CLUSTERED 
(
	[Employee_User_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Employee_User]') AND type = N'U')
BEGIN
    IF NOT EXISTS (SELECT 1 FROM [dbo].[Tbl_Employee_User])
    BEGIN
        INSERT INTO [dbo].[Tbl_Employee_User] (
            [Employee_Id], [User_Id], [LMS_access]
        )
        VALUES (
            1, 1, 'No'
        )
    END
END
