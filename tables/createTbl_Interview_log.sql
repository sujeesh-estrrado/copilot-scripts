-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Interview_log]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Interview_log](
	[Log_id] [bigint] IDENTITY(1,1) NOT NULL,
	[Candidate_id] [bigint] NULL,
	[Schedule_date] [datetime] NULL,
	[scheduled_by] [bigint] NULL,
	[result] [varchar](500) NULL,
	[Remark] [varchar](500) NULL,
	[Interview_Link] [varchar](500) NULL,
 CONSTRAINT [PK_Tbl_Interview_log] PRIMARY KEY CLUSTERED 
(
	[Log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

