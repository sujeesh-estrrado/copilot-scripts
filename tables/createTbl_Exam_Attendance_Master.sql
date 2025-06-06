-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Exam_Attendance_Master]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Exam_Attendance_Master](
	[Attendance_Master_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Attendance_SheetNo] [varchar](max) NULL,
	[Exam_Schedule_Id] [bigint] NULL,
	[Exam_Schedule_Details_Id] [bigint] NULL,
	[Approval_Status] [bigint] NULL,
	[Approved_By] [bigint] NULL,
	[Marked_By] [bigint] NULL,
	[Created_Date] [datetime] NULL,
	[Delete_Status] [bit] NULL,
	[Attnce_SerialNumber] [bigint] NULL,
	[Approval_Date] [datetime] NULL,
	[Hearing_Status] [bigint] NULL,
CONSTRAINT [PK_Tbl_Exam_Attendance_Master] PRIMARY KEY CLUSTERED 
(
	[Attendance_Master_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

