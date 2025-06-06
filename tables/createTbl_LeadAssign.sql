-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_LeadAssign]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_LeadAssign](
	[leadAssignID] [bigint] IDENTITY(1,1) NOT NULL,
	[Candidate_Id] [bigint] NOT NULL,
	[CounselorEmployee_id] [bigint] NOT NULL,
	[startDtim] [datetime] NOT NULL,
	[endDtim] [datetime] NULL,
	[assignByEmployee_id] [bigint] NULL,
	[isLatest] [tinyint] NOT NULL,
	[isPrev] [tinyint] NULL,
 CONSTRAINT [PK_Tbl_LeadAssign] PRIMARY KEY CLUSTERED 
(
	[leadAssignID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

