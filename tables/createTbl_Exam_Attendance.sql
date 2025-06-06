-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Exam_Attendance]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Exam_Attendance](
	[Attendance_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Attendance_Master_Id] [bigint] NULL,
	[Student_Id] [bigint] NULL,
	[Present] [bigint] NULL,
	[Misconduct] [bigint] NULL,
	[Misconduct_Remarks] [varchar](max) NULL,
	[Absent_Remarks] [varchar](max) NULL,
	[Approval_Status] [bigint] NULL,
	[Marked_By] [bigint] NULL,
	[Approved_By] [bigint] NULL,
	[Approved_Date] [datetime] NULL,
	[Created_Date] [datetime] NULL,
	[Delete_Status] [bit] NULL,
 CONSTRAINT [PK_Tbl_Exam_Attendance] PRIMARY KEY CLUSTERED 
(
	[Attendance_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

