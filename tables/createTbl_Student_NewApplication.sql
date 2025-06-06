-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Student_NewApplication]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Student_NewApplication](
	[New_Application_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Candidate_Id] [bigint] NULL,
	[Candidate_DelStatus] [bit] NULL,
	[New_Admission_Id] [bigint] NULL,
	[Option2] [bigint] NULL,
	[Option3] [bigint] NULL,
	[RegDate] [datetime] NULL,
	[CounselorCampus] [bigint] NULL,
	[Campus] [bigint] NULL,
	[CounselorEmployee_id] [bigint] NULL,
	[EnrollBy] [varchar](max) NULL,
	[Active_Status] [varchar](max) NULL,
	[IDMatrixNo] [varchar](max) NULL,
	[ApplicationStatus] [varchar](max) NULL,
	[FeeStatus] [varchar](max) NULL,
	[Mode_Of_Study] [varchar](max) NULL,
	[Edit_status] [bit] NULL,
	[Edit_request] [bit] NULL,
	[billoutstanding] [decimal](18, 2) NULL,
	[Invoice_Status] [varchar](max) NULL,
	[Payment_Request_Status] [varchar](max) NULL,
	[create_date] [datetime] NULL,
	[active] [bigint] NULL,
	[LastUpdate] [datetime] NULL,
	[Edit_request_remark] [varchar](max) NULL,
	[CouncelloAttendedLastDate] [varchar](max) NULL,
	[documentcomplete] [bigint] NULL,
	[Scolorship_Name] [varchar](max) NULL,
	[Scolorship_Remark] [varchar](max) NULL,
	[Initial_Application_Id] [bigint] NULL,
	[Editable] [bigint] NULL,
	[ButtonStatus] [varchar](max) NULL,
	[ApplicationStage] [varchar](max) NULL,
 CONSTRAINT [PK_Tbl_Student_NewApplication] PRIMARY KEY CLUSTERED 
(
	[New_Application_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

