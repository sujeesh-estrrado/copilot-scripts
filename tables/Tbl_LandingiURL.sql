-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_LandingiURL]') AND type = N'U')
BEGIN
CREATE TABLE [dbo].[Tbl_LandingiURL](
	[LandingiURL_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[LandingiURL_Name] [varchar](250) NULL,
  CONSTRAINT [PK_Tbl_LandingiURL] PRIMARY KEY CLUSTERED 
(
	[LandingiURL_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

