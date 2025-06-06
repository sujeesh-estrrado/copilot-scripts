-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_New_Admission]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[tbl_New_Admission](
	[New_Admission_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Course_Level_Id] [bigint] NULL,
	[Course_Category_Id] [bigint] NULL,
	[Department_Id] [bigint] NULL,
	[Batch_Id] [bigint] NULL,
	[FromDate] [datetime] NULL,
	[ToDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Admission_Status] [bit] NULL,
	[Course_Code] [nvarchar](50) NULL,
	[Intake_Number] [varchar](50) NULL,
	[Study_Mode] [varchar](50) NULL,
 CONSTRAINT [PK_tbl_New_Admission] PRIMARY KEY CLUSTERED 
(
	[New_Admission_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

