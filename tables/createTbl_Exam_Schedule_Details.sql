-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Exam_Schedule_Details]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Exam_Schedule_Details](
	[Exam_Schedule_Details_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Exam_Schedule_Id] [bigint] NULL,
	[Invigilator_mapping_id] [bigint] NULL,
	[Venue] [bigint] NULL,
	[ChiefInvigilator] [bigint] NULL,
	[Exam_Schedule_Details_Status] [bit] NULL,
	[Total_student_requested] [bigint] NULL,
 CONSTRAINT [PK_Tbl_Exam_Schedule_Details] PRIMARY KEY CLUSTERED 
(
	[Exam_Schedule_Details_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

