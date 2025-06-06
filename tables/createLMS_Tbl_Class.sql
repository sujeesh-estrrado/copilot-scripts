-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LMS_Tbl_Class]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[LMS_Tbl_Class](
		[Class_Id] [bigint] IDENTITY(1,1) NOT NULL,
		[Class_Name] [varchar](200) NULL,
		[Is_Existing_Class] [bit] NULL,
		[Type] [varchar](100) NULL,
		[Type_Id] [bigint] NULL,
		[Active_Status] [bit] NULL,
		[Delete_Status] [bit] NULL,
		CONSTRAINT [PK_LMS_Tbl_Class] PRIMARY KEY CLUSTERED 
		(
		[Class_Id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]
END

