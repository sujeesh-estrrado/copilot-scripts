-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[report]') AND type = N'U')
BEGIN
	CREATE TABLE [dbo].[report](
	[Agents] [varchar](20) NULL,
	[Signed] [int] NULL,
	[InProgress] [int] NULL
) ON [PRIMARY]
END

