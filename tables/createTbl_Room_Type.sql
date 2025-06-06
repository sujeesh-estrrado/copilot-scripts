-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Room_Type]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Room_Type](
	[Room_type_id] [bigint] IDENTITY(1,1) NOT NULL,
	[Room_type] [varchar](max) NULL,
	[Active_status] [bit] NULL,
	[delete_status] [bit] NULL,
CONSTRAINT [PK_Tbl_Room_Type] PRIMARY KEY CLUSTERED 
(
	[Room_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

