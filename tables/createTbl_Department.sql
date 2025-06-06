-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Department]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Department](
	[Department_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Department_Name] [varchar](max) NULL,
	[Department_Descripition] [varchar](max) NULL,
	[Department_Status] [bit] NULL,
	[Course_Code] [varchar](50) NULL,
	[Intro_Date] [datetime] NULL,
	[GraduationTypeId] [bigint] NULL,
	[Program_Type_Id] [bigint] NULL,
	[Org_Id] [int] NULL,
	[Submission_Date] [datetime] NULL,
	[MQA_code] [varchar](50) NULL,
	[matrix_prefix] [varchar](50) NULL,
	[fee] [varchar](50) NULL,
	[MQA_Approval_Date] [datetime] NULL,
	[MOE_Approval_Date] [datetime] NULL,
	[Payment_Date] [datetime] NULL,
	[Expiry_Date] [datetime] NULL,
	[Renewal_Code] [varchar](50) NULL,
	[Renewal_Date] [datetime] NULL,
	[Accreditation_Date] [datetime] NULL,
	[Active_Status] [varchar](10) NULL,
	[Created_Date] [datetime] NULL,
	[Updated_Date] [datetime] NULL,
	[Delete_Status] [bit] NULL,
	[AnnualPracticingCertification] [varchar](max) NULL,
	[Course_rereg_status] [bigint] NULL,
	[Hypothesiedcode] [varchar](max) NULL,
	[Online_checkstatus] [bigint] NULL,
	[PartnerUniversity] [varchar](max) NULL,
	[Modeofstudy] [bigint] NULL,
 CONSTRAINT [PK_Tbl_Department_New] PRIMARY KEY CLUSTERED 
(
	[Department_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

