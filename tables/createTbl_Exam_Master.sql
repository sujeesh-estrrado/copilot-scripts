-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Exam_Master]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Exam_Master](
	[Exam_Master_id] [bigint] IDENTITY(1,1) NOT NULL,
	[Duration_Period_id] [bigint] NULL,
	[Exam_Name] [varchar](max) NULL,
	[Exam_Type] [bigint] NULL,
	[Publish_status] [bigint] NULL,
	[exam_status] [bigint] NULL,
	[Final_Exam_status] [bit] NULL,
	[Exam_end_date] [datetime] NULL,
	[Exam_start_date] [datetime] NULL,
	[Create_date] [datetime] NULL,
	[Created_by] [bigint] NULL,
	[Publish_date] [datetime] NULL,
	[Publish_by] [bigint] NULL,
	[Updated_by] [bigint] NULL,
	[Update_date] [datetime] NULL,
	[delete_status] [bit] NULL,
	[RePublish_status] [bigint] NULL,
	[ExamDep_Approval] [bigint] NULL,
	[Registrar_Approval] [bigint] NULL,
	[PublishType] [bigint] NULL,
	[Result_PublishStatus] [bigint] NULL,
 CONSTRAINT [PK_Tbl_Exam_Master] PRIMARY KEY CLUSTERED 
(
	[Exam_Master_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

