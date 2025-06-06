-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Student_Tc_request]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Student_Tc_request](
	[Tc_request_id] [bigint] IDENTITY(1,1) NOT NULL,
	[Candidate_id] [bigint] NULL,
	[Request_type] [varchar](50) NULL,
	[Remark] [varchar](max) NULL,
	[Faculty_id] [bigint] NULL,
	[Faculty_remark] [varchar](max) NULL,
	[Request_status] [varchar](50) NULL,
	[Counselor_id] [bigint] NULL,
	[Counselling_Status] [bit] NULL,
	[Create_date] [datetime] NULL,
	[Delete_status] [bit] NULL,
	[Update_date] [datetime] NULL,
	[Final_Approval_date] [datetime] NULL,
	[Final_Approval_Remark] [varchar](max) NULL,
	[Finance_approval_requestID] [bigint] NULL,
 CONSTRAINT [PK_Tbl_Student_Tc_request] PRIMARY KEY CLUSTERED 
(
	[Tc_request_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

