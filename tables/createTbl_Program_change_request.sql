-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Program_change_request]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Program_change_request](
	[Program_change_id] [bigint] IDENTITY(1,1) NOT NULL,
	[Candidate_id] [bigint] NULL,
	[Course_level_id] [bigint] NULL,
	[Department_id] [bigint] NULL,
	[batchid] [bigint] NULL,
	[new_admission_id] [bigint] NULL,
	[old_admission_id] [bigint] NULL,
	[Application_status] [varchar](50) NULL,
	[Updated_by] [bigint] NULL,
	[create_date] [datetime] NULL,
	[update_date] [datetime] NULL,
	[delete_status] [bit] NULL,
  CONSTRAINT [PK_Tbl_Program_change_request] PRIMARY KEY CLUSTERED 
(
	[Program_change_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

