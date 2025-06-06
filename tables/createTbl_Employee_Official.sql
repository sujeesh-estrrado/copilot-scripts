-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Employee_Official]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Employee_Official](
	[Employee_Official_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Employee_DOJ] [datetime] NULL,
	[Employee_Probation_Period] [varchar](50) NULL,
	[Employee_Confirmation_Date] [datetime] NULL,
	[Employee_Pan_No] [varchar](50) NULL,
	[Employee_Esi_No] [varchar](50) NULL,
	[Employee_Payment_mode] [varchar](50) NULL,
	[Employee_Bank_Account_No] [varchar](50) NULL,
	[Employee_Bank_Name] [varchar](200) NULL,
	[Employee_Mode_Job] [varchar](200) NULL,
	[Employee_Reporting_Staff] [varchar](200) NULL,
	[Employee_Official_Status] [bit] NULL,
	[Employee_Id] [bigint] NULL,
	[Department_Id] [bigint] NULL,
	[PFNO] [varchar](50) NULL,
	[BasicSalary] [decimal](18, 2) NULL,
	[SocsoNo] [varchar](50) NULL,
	[KwspNo] [varchar](50) NULL,
	[Insurance_detail] [varchar](200) NULL,
	[Designation_Id] [varchar](200) NULL,
	[Created_Date] [datetime] NULL,
	[Updated_Date] [datetime] NULL,
	[Delete_Status] [bit] NULL,
	[ResignedDate] [datetime] NULL,
	[ExtendResignedDate] [datetime] NULL,
	[OfficialLastDate] [datetime] NULL,
CONSTRAINT [PK_Tbl_Employee_Official] PRIMARY KEY CLUSTERED 
(
	[Employee_Official_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

