-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NationalityTemplateMapping]') AND type = N'U')
BEGIN
CREATE TABLE [dbo].[NationalityTemplateMapping](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Nationality] [nvarchar](250) NOT NULL,
	[NationalityId] [bigint] NULL,
	[TemplateId] [bigint] NULL,
	[DelStatus] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

