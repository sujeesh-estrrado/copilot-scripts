-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Notice_Faculty_Maping]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Notice_Faculty_Maping](
		[Nf_Id] [bigint] IDENTITY(1,1) NOT NULL,
		[Notice_Id] [bigint] NULL,
		[Faculty_Id] [bigint] NULL,
		[Delete_Status] [int] NULL,
		CONSTRAINT [PK_Notice_Faculty_Maping] PRIMARY KEY CLUSTERED 
		(
		[Nf_Id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]
END

