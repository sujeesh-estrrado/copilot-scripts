-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_ExamDocket]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_ExamDocket](
	[Docket_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Docket_number] [varchar](max) NULL,
	[TimeTable_Id] [bigint] NULL,
	[Student_Id] [bigint] NULL,
	[DocketPrintCount] [bigint] NULL,
	[Created_Date] [datetime] NULL,
	[Updated_Date] [datetime] NULL,
	[Delete_Status] [bit] NULL,
	[Docket_SerialNumber] [bigint] NULL,
	[DocketView_Status] [bigint] NULL,
 CONSTRAINT [PK_Tbl_ExamDocket] PRIMARY KEY CLUSTERED 
(
	[Docket_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

