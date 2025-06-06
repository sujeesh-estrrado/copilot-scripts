-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Defer_Status]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Defer_Status](
	[Defer_ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Candidate_ID] [bigint] NULL,
	[Date_Of_Return] [datetime] NULL,
	[Status] [bit] NULL,
	[delete_status] [bit] NULL,
	[IntakeId] [bigint] NULL,
CONSTRAINT [PK_Tbl_Defer_Status] PRIMARY KEY CLUSTERED 
(
	[Defer_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

