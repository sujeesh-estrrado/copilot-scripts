-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Notice_Link_Maping]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Notice_Link_Maping](
		[Nl] [bigint] IDENTITY(1,1) NOT NULL,
		[Notice_Id] [bigint] NULL,
		[Link_Id] [nvarchar](255) NULL,
		[Delete_Status] [bigint] NULL,
		CONSTRAINT [PK_Notice_Link_Maping] PRIMARY KEY CLUSTERED 
		(
		[Nl] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]
END

