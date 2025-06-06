-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[temp1]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[temp1](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[ApplicationPending] [bigint] NOT NULL,
	[ApplicationSubmitted] [bigint] NOT NULL,
	[MarketingApproved] [bigint] NOT NULL,
	[AdmissionVerified] [bigint] NOT NULL,
	[PreActivated] [bigint] NOT NULL,
	[OfferLetterSent] [bigint] NOT NULL,
	[OfferLetterAccepted] [bigint] NOT NULL,
	[Activated] [bigint] NOT NULL,
	[Totalrecords] [bigint] NOT NULL,
	[per_ApplicationPending] [varchar](max) NOT NULL,
	[per_ApplicationSubmitted] [varchar](max) NOT NULL,
	[per_MarketingApproved] [varchar](max) NOT NULL,
	[per_AdmissionVerified] [varchar](max) NOT NULL,
	[per_PreActivated] [varchar](max) NOT NULL,
	[per_OfferLetterSent] [varchar](max) NOT NULL,
	[per_OfferLetterAccepted] [varchar](max) NOT NULL,
	[per_Activated] [varchar](max) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

