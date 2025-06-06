-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Student_Absence]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Student_Absence](
	[Absent_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Candidate_Id] [bigint] NOT NULL,
	[Duration_Mapping_Id] [bigint] NOT NULL,
	[Absent_Date] [datetime] NOT NULL,
	[Absent_Type] [varchar](150) NULL,
	[Class_Timings_Id] [bigint] NULL,
	[Course_Department_Id] [bigint] NULL,
	[Subject_Id] [bigint] NULL,
	[Remark] [nvarchar](max) NULL,
	[employee_Id] [bigint] NULL,
	[DeleteStatus] [bit] NOT NULL,
  CONSTRAINT [PK_Tbl_Student_Absence] PRIMARY KEY CLUSTERED 
(
	[Absent_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

