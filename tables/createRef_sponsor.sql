-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ref_sponsor]') AND type = N'U')
BEGIN
	CREATE TABLE [dbo].[ref_sponsor](
	[sponsorid] [bigint] IDENTITY(1,1) NOT NULL,
	[sponsorname] [varchar](100) NULL,
	[contactperson] [varchar](50) NULL,
	[contactnumber] [varchar](13) NULL,
	[cgpa] [float] NULL,
	[staffid] [bigint] NULL,
	[description] [varchar](255) NULL,
	[address] [varchar](500) NULL,
	[DelStatus] [bit] NULL,
	CONSTRAINT [PK_ref_sponsor] PRIMARY KEY CLUSTERED 
(
	[sponsorid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

