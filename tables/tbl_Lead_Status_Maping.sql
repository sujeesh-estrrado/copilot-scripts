-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Lead_Status_Maping]') AND type = N'U')
BEGIN

CREATE TABLE [dbo].[tbl_Lead_Status_Maping](
	[mp] [bigint] IDENTITY(1,1) NOT NULL,
	[Pipeline_Id] [bigint] NULL,
	[Lead_Satus_Id] [bigint] NULL,
	[Lead_Status_Del] [bigint] NULL,
 CONSTRAINT [PK_tbl_Lead_Status_Maping] PRIMARY KEY CLUSTERED 
(
	[mp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

