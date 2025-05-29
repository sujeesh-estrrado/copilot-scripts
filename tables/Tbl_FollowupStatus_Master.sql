-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_FollowupStatus_Master]') AND type = N'U')
BEGIN

CREATE TABLE [dbo].[Tbl_FollowupStatus_Master](
	[Followp_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Followup_Name] [varchar](50) NOT NULL,
	[Followup_DelStatus] [bit] NOT NULL,
	[Followup_CreatedBy] [bigint] NULL,
	[Foolowup_CreatedDate] [datetime] NULL,
	[Followup_UpdateBy] [bigint] NULL,
	[Followup_UpdatedDate] [datetime] NULL,
	[Followup_DelDate] [datetime] NULL,
 CONSTRAINT [PK_Tbl_FollowupStatus_Master] PRIMARY KEY CLUSTERED 
(
	[Followp_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

