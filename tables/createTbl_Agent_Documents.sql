-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Agent_Documents]') AND type = N'U')
BEGIN
	CREATE TABLE [dbo].[Tbl_Agent_Documents](
	[Document_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Agent_Id] [bigint] NULL,
	[Document_Path] [varchar](max) NULL,
	[Title] [varchar](max) NULL,
	[Created_Date] [datetime] NULL,
	[Updated_Date] [datetime] NULL,
	[Delete_status] [bit] NULL,
   CONSTRAINT [PK_Agent_Documents] PRIMARY KEY CLUSTERED 
(
	[Document_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

