-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_ReEvaluation_Fee_Master]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_ReEvaluation_Fee_Master](
	[ReEvaluation_Fee_Master_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Faclty_Id] [bigint] NULL,
	[Programme_Id] [bigint] NULL,
	[Intake_Id] [bigint] NULL,
	[Semester_Id] [bigint] NULL,
	[Created_Date] [datetime] NULL,
	[delete_Status] [bit] NULL,
 CONSTRAINT [PK_Tbl_ReEvaluation_Fee_Master] PRIMARY KEY CLUSTERED 
(
	[ReEvaluation_Fee_Master_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

