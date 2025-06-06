-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_LeadStatus_Change_by_Marketing]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_LeadStatus_Change_by_Marketing](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[Candidate_Id] [bigint] NOT NULL,
	[Status_Changed_By] [bigint] NULL,
	[status] [varchar](500) NULL,
	[Create_Date] [datetime] NULL,
	[delete_status] [bit] NULL,
 CONSTRAINT [PK_Tbl_LeadStatus_Change_by_Marketing] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

