-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ref_accountcode]') AND type = N'U')
BEGIN
	CREATE TABLE [dbo].[ref_accountcode](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[code] [varchar](60) NULL,
	[name] [varchar](300) NULL,
	[description] [varchar](765) NULL,
	[odr] [int] NULL,
	[active] [bigint] NULL,
	[flagledger] [char](1) NULL,
	[taxcode_id] [char](1) NULL,
	[deleteStatus] [bit] NULL,
	[createdDate] [datetime] NULL,
	[updatedDate] [datetime] NULL,
	[sales] [bit] NULL,
	CONSTRAINT [PK_ref_accountcode] PRIMARY KEY CLUSTERED 
	(
	[id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
END

