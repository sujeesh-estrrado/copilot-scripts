-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_certificate_master]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[tbl_certificate_master](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Document_Name] [varchar](50) NULL,
	[Type_of_student] [varchar](100) NULL,
	[Category_id] [bigint] NULL,
	[Delete_Status] [bit] NULL,
	[StaticDoc] [bit] NULL,
 CONSTRAINT [PK_tbl_certificate_master] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

