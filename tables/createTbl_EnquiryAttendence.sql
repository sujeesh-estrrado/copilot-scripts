-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_EnquiryAttendence]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_EnquiryAttendence](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[CandidateID] [bigint] NULL,
	[CouncellorID] [bigint] NULL,
	[AttendedDateTime] [datetime] NULL,
	[Delete_status] [bit] NULL,
 CONSTRAINT [PK_Tbl_EnquiryAttendence] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

