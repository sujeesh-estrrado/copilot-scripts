-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Candidate_Englishtest]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Candidate_Englishtest](
	[Add_English_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[English_Text_Id] [bigint] NULL,
	[Grade] [varchar](max) NULL,
	[Type] [varchar](max) NULL,
	[Cand_Id] [bigint] NULL,
	[Created_Date] [datetime] NULL,
	[Updated_Date] [datetime] NULL,
	[Delete_Status] [bit] NULL,
	[TestYear] [varchar](20) NULL,
	 CONSTRAINT [PK_Tbl_Candidate_Englishtest] PRIMARY KEY CLUSTERED 
(
	[Add_English_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

