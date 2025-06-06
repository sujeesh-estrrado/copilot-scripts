-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblTemp_Password]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[tblTemp_Password](
	[temp_password_Id] [int] IDENTITY(1,1) NOT NULL,
	[user_Id] [int] NULL,
 CONSTRAINT [PK_tblTemp_Password] PRIMARY KEY CLUSTERED 
(
	[temp_password_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

