-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_StudentDocUpload]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[tbl_StudentDocUpload](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[StudentId] [bigint] NULL,
	[DocType] [bigint] NULL,
	[DocumentName] [varchar](200) NULL,
	[DocumentLoc] [varchar](max) NULL,
	[MarketingVerify] [bit] NULL,
	[MarketingVerifyBy] [bigint] NULL,
	[MarketingRejectionRemark] [varchar](max) NULL,
	[AdmissionVerify] [bit] NULL,
	[AdmissionVerifyBy] [bigint] NULL,
	[AdmissionRejectionRemark] [varchar](max) NULL,
	[CreatedDateDate] [date] NULL,
	[LastUpdated] [date] NULL,
	[DeleteStatus] [bit] NULL,
	[MarketingVerifydate] [datetime] NULL,
	[AdmissionVerifydate] [datetime] NULL,
	[IsInternal] [bit] NOT NULL,
  CONSTRAINT [PK_tbl_StudentDocUpload] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

