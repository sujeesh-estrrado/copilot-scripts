-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Placement_Schedule_Log]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Placement_Schedule_Log](
	[schedule_id] [bigint] IDENTITY(1,1) NOT NULL,
	[Placement_date] [date] NULL,
	[Placement_venue] [varchar](500) NULL,
	[Placement_Time] [varchar](50) NULL,
	[Placement_status] [varchar](50) NULL,
	[Scheduled_by] [bigint] NULL,
	[candidate_id] [bigint] NULL,
	[Staff_id] [bigint] NULL,
	[reschedule_date] [date] NULL,
	[rechedule_count] [varchar](50) NULL,
	[create_date] [datetime] NULL,
	[delete_status] [bit] NULL,
 CONSTRAINT [PK_Tbl_Placement_Schedule_Log] PRIMARY KEY CLUSTERED 
(
	[schedule_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

