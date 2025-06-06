-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[student_statuslog]') AND type = N'U')
BEGIN
	CREATE TABLE [dbo].[student_statuslog](
	[statuslogid] [bigint] IDENTITY(1,1) NOT NULL,
	[studentid] [bigint] NULL,
	[courseid] [bigint] NULL,
	[oldcourseid] [bigint] NULL,
	[oldmatrixno] [varchar](max) NULL,
	[newmatrixno] [varchar](max) NULL,
	[currentstatus] [bigint] NULL,
	[newstatus] [bigint] NULL,
	[dateeffective] [date] NULL,
	[datechange] [date] NULL,
	[changeby] [bigint] NULL,
	[datedeferred] [date] NULL,
	[datereturn] [date] NULL,
	[remarks] [varchar](max) NULL,
	  CONSTRAINT [PK_student_statuslog] PRIMARY KEY CLUSTERED 
(
	[statuslogid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

