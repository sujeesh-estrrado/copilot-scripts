-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Notice_Role_Maping]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Notice_Role_Maping](
		[Nr_Id] [bigint] IDENTITY(1,1) NOT NULL,
		[Notice_Id] [bigint] NULL,
		[Role_Id] [bigint] NULL,
		[Delete_Status] [bigint] NULL,
		CONSTRAINT [PK_Notice_Role_Maping] PRIMARY KEY CLUSTERED 
		(
		[Nr_Id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]
END

