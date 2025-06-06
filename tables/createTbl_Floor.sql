-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Floor]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Floor](
	[Floor_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Floor_Name] [varchar](200) NOT NULL,
	[Floor_Code] [varchar](50) NOT NULL,
	[Floor_DelStatus] [bit] NOT NULL,
 CONSTRAINT [PK_Tbl_Floor] PRIMARY KEY CLUSTERED 
(
	[Floor_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

