-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InterestlevelTemplateMapping]') AND type = N'U')
BEGIN
 CREATE TABLE [dbo].[InterestlevelTemplateMapping](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Interestlevel] [nvarchar](250) NOT NULL,
	[InterestId] [bigint] NULL,
	[TemplateId] [bigint] NULL,
	[DelStatus] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

