-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[student_sponsor]') AND type = N'U')
BEGIN
	CREATE TABLE [dbo].[student_sponsor](
	[studentsponsorid] [bigint] IDENTITY(1,1) NOT NULL,
	[studentid] [bigint] NULL,
	[sponsorid] [bigint] NULL,
	[referenceno] [varchar](150) NULL,
	[amount] [decimal](18, 2) NULL,
	[durationstart] [date] NULL,
	[durationend] [date] NULL,
	[sponsorstatus] [bigint] NULL,
	[createdby] [bigint] NULL,
	[datecreated] [datetime] NULL,
	[updatedby] [bigint] NULL,
	[dateupdated] [datetime] NULL,
	[DelStatus] [bit] NULL,
	 CONSTRAINT [PK_student_sponsor] PRIMARY KEY CLUSTERED 
(
	[studentsponsorid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

