-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Assessment_Code_Master]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Assessment_Code_Master](
		[Assessment_Code_Id] [bigint] IDENTITY(1,1) NOT NULL,
		[Assessment_Code] [varchar](50) NULL,
		[Assessment_Desc] [varchar](100) NULL,
		CONSTRAINT [PK_Tbl_Assessment_Code_Master] PRIMARY KEY CLUSTERED 
		(
		[Assessment_Code_Id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]
END

