-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_certificate_maping]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[tbl_certificate_maping](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Certificate_id] [int] NULL,
	[program_code] [varchar](max) NULL,
	[status] [bit] NULL,
	[IsMandatory] [bit] NULL,
 CONSTRAINT [PK_tbl_certificate_maping] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

