-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_LeadSearchTemplate]') AND type = N'U')
BEGIN
CREATE TABLE [dbo].[Tbl_LeadSearchTemplate](
	[TemplateId] [bigint] IDENTITY(1,1) NOT NULL,
	[TabName] [nvarchar](max) NULL,
	[NationalityID] [bigint] NULL,
	[LeadstatusID] [bigint] NULL,
	[SourceId] [bigint] NULL,
	[InterestlevelId] [bigint] NULL,
	[CounsellorId] [bigint] NULL,
	[FollowupDateFrom] [datetime] NULL,
	[FollowupDateTo] [datetime] NULL,
	[CreatedDateFrom] [datetime] NULL,
	[CreatedDateTo] [datetime] NULL,
	[CreatedBy] [bigint] NULL,
	[DelStatus] [int] NULL,
 CONSTRAINT [PK_Tbl_SearchTemplate] PRIMARY KEY CLUSTERED 
(
	[TemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

