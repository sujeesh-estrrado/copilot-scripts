-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Title]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Title](
	[Title_Id] [int] NOT NULL,
	[Title_Name] [varchar](100) NOT NULL
) ON [PRIMARY]
END

