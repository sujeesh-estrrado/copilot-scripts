-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Notice_Board]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[tbl_Notice_Board](
	[Notice_Id] [int] IDENTITY(1,1) NOT NULL,
	[Faculty] [bigint] NULL,
	[Program] [bigint] NULL,
	[Intake] [bigint] NULL,
	[StudentName] [varchar](100) NULL,
	[Department] [bigint] NULL,
	[Role] [bigint] NULL,
	[EmployeeName] [varchar](100) NULL,
	[Subject] [varchar](100) NULL,
	[Annoncement] [varchar](max) NULL,
	[Notice_Doc] [varchar](max) NULL,
	[Createdate] [date] NULL,
	[Select_All_Students] [bigint] NULL,
	[Select_All_Employee] [bigint] NULL,
	[Notify_Email] [bigint] NULL,
	[Notify_Sms] [bigint] NULL,
	[Notify_Watsapp] [bigint] NULL,
	[Notify_Urgently] [bigint] NULL,
	[Selected_Students] [bigint] NULL,
	[Selected_Employee] [bigint] NULL,
	[Notice_Created] [bigint] NULL,
	[External_Link] [varchar](max) NULL,
 CONSTRAINT [PK_tbl_Notice_Board] PRIMARY KEY CLUSTERED 
(
	[Notice_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

