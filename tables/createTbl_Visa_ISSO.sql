-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Visa_ISSO]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Visa_ISSO](
	[Visa_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Candidate_Id] [bigint] NOT NULL,
	[Visa_Type] [varchar](500) NULL,
	[Visa_Expiry] [date] NULL,
	[Duration] [varchar](50) NULL,
	[Visa_Status] [varchar](500) NULL,
	[Expiry_Status] [int] NULL,
	[Applied_Date] [date] NULL,
	[Del_Status] [int] NULL,
	[Remark] [varchar](500) NULL,
	[Reject_Remark] [nvarchar](max) NULL,
	[Passport_visa_ExpiryDate] [date] NULL,
CONSTRAINT [PK_Tbl_Visa_ISSO] PRIMARY KEY CLUSTERED 
(
	[Visa_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

