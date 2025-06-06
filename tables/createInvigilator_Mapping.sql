-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Invigilator_Mapping]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Invigilator_Mapping](
		[InvigilatorMapping_id] [bigint] IDENTITY(1,1) NOT NULL,
		[Exam_Schedule_Details_Id] [bigint] NULL,
		[Employee_id] [bigint] NULL,
		[delete_status] [bit] NULL,
		CONSTRAINT [PK_Invigilator_Mapping] PRIMARY KEY CLUSTERED 
		(
		[InvigilatorMapping_id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]
END

