-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Status_change_by_Marketing]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Status_change_by_Marketing](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[Candidate_id] [bigint] NOT NULL,
	[Status_changed_by] [bigint] NULL,
	[status] [varchar](500) NULL,
	[Create_date] [datetime] NULL,
	[delete_status] [bit] NULL,
   CONSTRAINT [PK_Tbl_Status_change_by_Marketing] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

