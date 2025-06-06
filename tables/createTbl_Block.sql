-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Block]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Block](
	[Block_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Block_Name] [varchar](200) NOT NULL,
	[Block_Code] [varchar](50) NOT NULL,
	[Block_DelStatus] [bit] NOT NULL DEFAULT(0),
	CONSTRAINT [PK_Tbl_Block] PRIMARY KEY CLUSTERED 
(
	[Block_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
    
END

