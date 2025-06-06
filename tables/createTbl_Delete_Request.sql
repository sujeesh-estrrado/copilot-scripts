-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Delete_Request]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Delete_Request](
	[Delete_request_id] [bigint] IDENTITY(1,1) NOT NULL,
	[Candidate_id] [bigint] NULL,
	[Delete_request_status] [varchar](500) NULL,
	[Registrar_remark] [varchar](max) NULL,
	[Requested_by] [bigint] NULL,
	[Request_date] [datetime] NULL,
	[Create_date] [datetime] NULL,
	[Delete_status] [bit] NULL,
	[Remarks] [varchar](max) NULL,
	[Reject_remark] [varchar](max) NULL,
 CONSTRAINT [PK_Tbl_Delete_Request] PRIMARY KEY CLUSTERED 
(
	[Delete_request_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

