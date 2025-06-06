-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_ExamPublish]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_ExamPublish](
    [Exam_Publish_Id] [bigint] IDENTITY(1,1) NOT NULL,
    [Exam_Master_Id] [bigint] NOT NULL,
    [Exam_Schedule_Id] [bigint] NOT NULL,
    [Course_Id] [bigint] NOT NULL,
    [Exam_Date] [date] NOT NULL,
    [Exam_Time_from] [time](7) NOT NULL,
    [Exam_Time_To] [time](7) NOT NULL,
    [Venue] [bigint] NOT NULL,
    [Del_Status] [bigint] NOT NULL,
 CONSTRAINT [PK_Tbl_ExamPublish] PRIMARY KEY CLUSTERED 
(
    [Exam_Publish_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

