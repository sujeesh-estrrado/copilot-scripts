-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Employee_Certificates]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Employee_Certificates](
	[Certificate_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Employee_Id] [bigint] NOT NULL,
	[Title] [varchar](50) NULL,
	[Image_Path] [varchar](500) NOT NULL,
 CONSTRAINT [PK_Tbl_Employee_Certificates] PRIMARY KEY CLUSTERED 
(
	[Certificate_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

