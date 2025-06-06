-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ref_bank]') AND type = N'U')
BEGIN
	CREATE TABLE [dbo].[ref_bank](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[code] [varchar](20) NULL,
	[name] [varchar](100) NULL,
	[description] [varchar](255) NULL,
	[odr] [bigint] NULL,
	[active] [bigint] NULL,
	CONSTRAINT [PK_ref_bank] PRIMARY KEY CLUSTERED 
	(
	[id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
END

