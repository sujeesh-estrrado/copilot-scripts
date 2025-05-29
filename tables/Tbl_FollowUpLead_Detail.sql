-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_FollowUpLead_Detail]') AND type = N'U')
BEGIN
CREATE TABLE [dbo].[Tbl_FollowUpLead_Detail](
	[Follow_Up_Detail_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Counselor_Employee] [varchar](200) NULL,
	[Candidate_Id] [bigint] NULL,
	[Followup_Date] [datetime] NULL,
	[Followup_time] [varchar](50) NULL,
	[Remarks] [varchar](200) NULL,
	[Respond_Type] [varchar](200) NULL,
	[Action_to_Be_Taken] [varchar](200) NULL,
	[Action_Taken] [bit] NULL,
	[Next_Date] [datetime] NULL,
	[Medium] [varchar](50) NULL,
	[Delete_Status] [bit] NULL,
	[Call_Duration] [varchar](20) NULL,
	[LeadStatus_Id] [bigint] NULL,
 CONSTRAINT [PK_Tbl_FollowUpLead_Detail] PRIMARY KEY CLUSTERED 
(
	[Follow_Up_Detail_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

