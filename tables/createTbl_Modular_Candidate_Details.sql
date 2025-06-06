-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Modular_Candidate_Details]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Modular_Candidate_Details](
    [Modular_Candidate_Id] [bigint] IDENTITY(1,1) NOT NULL,
    [Ic_Passport] [varchar](50) NOT NULL,
    [Salutation] [varchar](50) NULL,
    [Candidate_Fname] [varchar](100) NULL,
    [Candidate_Lname] [varchar](100) NULL,
    [Email] [varchar](50) NULL,
    [Contact] [bigint] NULL,
    [Type] [varchar](50) NULL,
    [Country] [bigint] NULL,
    [Gender] [varchar](50) NULL,
    [Modular_Course_Id] [bigint] NULL,
    [Modular_Slot_Id] [bigint] NULL,
    [Create_Date] [date] NULL,
    [Delete_Status] [bigint] NULL,
    [Country_Code] [varchar](50) NULL,
    [Candidate_Id] [bigint] NULL,
    [Payment_Method] [varchar](50) NULL,
    [SponsorID] [varchar](50) NULL,
    [Status] [varchar](100) NULL,
    [Application_Status] [varchar](50) NOT NULL,
    [ActivatedStatus] [int] NOT NULL,
CONSTRAINT [PK_Tbl_Modular_Candidate_Details] PRIMARY KEY CLUSTERED 
(
    [Modular_Candidate_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
