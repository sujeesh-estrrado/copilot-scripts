-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Student_Subject_Master]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Student_Subject_Master](
	[Student_Subject_Map_Master] [bigint] IDENTITY(1,1) NOT NULL,
	[Department_Id] [bigint] NULL,
	[Duration_Mapping_Id] [bigint] NULL,
	[Candidate_Id] [bigint] NULL,
CONSTRAINT [PK_Tbl_Student_Subject_Map] PRIMARY KEY CLUSTERED 
(
	[Student_Subject_Map_Master] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

