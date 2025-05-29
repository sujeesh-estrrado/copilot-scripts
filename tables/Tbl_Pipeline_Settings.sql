-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Pipeline_Settings]') AND type = N'U')
BEGIN

CREATE TABLE [dbo].[Tbl_Pipeline_Settings](
	[Pipeline_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Pipeline_Name] [varchar](255) NULL,
	[Linked_Lead_Status] [bigint] NULL,
	[Priority] [bigint] NULL,
	[Delete_Status] [bigint] NULL,
	[Created_By] [bigint] NULL,
	[Created_date] [datetime] NULL,
	[Colour] [varchar](10) NULL,
 CONSTRAINT [PK_Tbl_Pipeline_Settings] PRIMARY KEY CLUSTERED 
(
	[Pipeline_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

