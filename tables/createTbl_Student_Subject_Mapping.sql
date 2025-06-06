-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Student_Subject_Mapping]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Student_Subject_Mapping](
	[StudentCourse_Mapping_id] [bigint] IDENTITY(1,1) NOT NULL,
	[Student_id] [bigint] NULL,
	[Subject_id] [bigint] NULL,
	[Subject_status] [bigint] NULL,
	[approval_date] [datetime] NULL,
	[approved_by] [bigint] NULL,
	[delete_status] [bit] NULL,
	[Create_date] [datetime] NULL,
 CONSTRAINT [PK_Tbl_Student_Subject_Mapping] PRIMARY KEY CLUSTERED 
(
	[StudentCourse_Mapping_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

