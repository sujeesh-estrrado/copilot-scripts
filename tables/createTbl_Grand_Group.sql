-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Grand_Group]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Grand_Group](
	[GrandGroupCodeId] [bigint] IDENTITY(1,1) NOT NULL,
	[GrandGroupCode] [varchar](250) NULL,
	[GrandGroupDesc] [varchar](250) NULL,
	[delstatus] [int] NULL,
  CONSTRAINT [PK_Tbl_Grand_Group] PRIMARY KEY CLUSTERED 
(
	[GrandGroupCodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

