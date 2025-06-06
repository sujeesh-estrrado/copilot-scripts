-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_ProviderMaster]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_ProviderMaster](
	[ProviderId] [bigint] IDENTITY(1,1) NOT NULL,
	[ProviderCode] [varchar](50) NULL,
	[ProviderName] [varchar](50) NULL,
	[ProviderSecondName] [varchar](50) NULL,
	[ProviderAddress] [varchar](max) NULL,
	[ProviderTelephone] [varchar](20) NULL,
	[ProviderFax] [varchar](50) NULL,
	[ProviderEmail] [varchar](50) NULL,
	[Status] [bigint] NULL,
  CONSTRAINT [PK_Tbl_ProviderMaster] PRIMARY KEY CLUSTERED 
(
	[ProviderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

