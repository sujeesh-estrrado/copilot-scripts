-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Counsellor_Teamforming]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Counsellor_Teamforming](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Team_Id] [bigint] NULL,
	[TeamName] [varchar](100) NULL,
	[TeamLead] [int] NULL,
	[TeamMembers] [int] NULL,
	[DelStatus] [int] NOT NULL,
 CONSTRAINT [PK_Tbl_Counsellor_Teamforming] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

