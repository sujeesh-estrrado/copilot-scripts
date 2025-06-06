-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Skip_CheckPoint]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Skip_CheckPoint](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[candidate_id] [bigint] NULL,
	[Request_remark] [varchar](max) NULL,
	[Requested_by] [bigint] NULL,
	[Requested_date] [datetime] NULL,
	[Approved_remark] [varchar](max) NULL,
	[Approved_by] [bigint] NULL,
	[Approval_status] [bigint] NULL,
	[Approved_date] [datetime] NULL,
	[delete_status] [bit] NULL,
 CONSTRAINT [PK_Tbl_Skip_CheckPoint] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

