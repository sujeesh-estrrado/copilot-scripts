-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Candidate_ContactDetails_Mapping]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Candidate_ContactDetails_Mapping](
	[Cand_Contact_Mapping_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Cand_ContactDet_Id] [bigint] NULL,
	[Parent_Icpassport_No] [varchar](max) NULL,
	[Contact_person_Name] [varchar](max) NULL,
	[Contact_Relationship] [varchar](max) NULL,
	[Contact_Mob] [varchar](max) NULL,
	[Contact_Telephone] [varchar](max) NULL,
	[Contact_Mail] [varchar](max) NULL,
	[Contact_Address1] [varchar](max) NULL,
	[Contact_Address2] [varchar](max) NULL,
	[Contact_PostCode] [varchar](max) NULL,
	[Contact_Residing_Country] [varchar](max) NULL,
	[Contact_state] [varchar](max) NULL,
	[Contact_City] [varchar](max) NULL,
	[Candidate_Id] [bigint] NULL,
	[Created_Date] [datetime] NULL,
	[Updated_Date] [datetime] NULL,
	[Delete_Status] [bit] NULL,
CONSTRAINT [PK_Tbl_Candidate_ContactDetails_Mapping] PRIMARY KEY CLUSTERED 
(
	[Cand_Contact_Mapping_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

