-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Notice_Program_Maping]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Notice_Program_Maping](
		[Np_Id] [bigint] IDENTITY(1,1) NOT NULL,
		[Notice_Id] [bigint] NULL,
		[Program_Id] [bigint] NULL,
		[Delete_Status] [bigint] NULL,
		CONSTRAINT [PK_Notice_Program_Maping] PRIMARY KEY CLUSTERED 
		(
		[Np_Id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]
END

