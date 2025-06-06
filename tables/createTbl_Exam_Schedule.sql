-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Exam_Schedule]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Exam_Schedule](
	[Exam_Schedule_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Exam_Name] [varchar](100) NOT NULL,
	[Exam_Type_Id] [bigint] NOT NULL,
	[Course_id] [bigint] NULL,
	[Exam_Master_Id] [bigint] NOT NULL,
	[Exam_Date] [date] NOT NULL,
	[Exam_Time_From] [time](7) NULL,
	[Exam_Time_To] [time](7) NULL,
	[create_date] [datetime] NULL,
	[Created_by] [bigint] NULL,
	[Is_Result_Published] [bit] NOT NULL,
	[Exam_Schedule_Status] [bit] NOT NULL,
	[Is__Published] [bit] NULL,
 CONSTRAINT [PK_Tbl_Exam_Schedule] PRIMARY KEY CLUSTERED 
(
	[Exam_Schedule_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

