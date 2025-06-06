-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Teams]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Teams](
	[Team_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Team_Lead] [bigint] NULL,
	[Team_Name] [varchar](50) NULL,
 CONSTRAINT [PK_Tbl_Teams] PRIMARY KEY CLUSTERED 
(
	[Team_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

