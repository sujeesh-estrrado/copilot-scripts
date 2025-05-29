-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Acceptance_letter]') AND type = N'U')
BEGIN
CREATE TABLE [dbo].[Tbl_Acceptance_letter](
	[Acceptence_id] [bigint] IDENTITY(1,1) NOT NULL,
	[Candidate_id] [bigint] NULL,
	[Letter_path] [varchar](max) NULL,
	[Create_date] [datetime] NULL,
	[Delete_Status] [bit] NULL,
	[OfferLetterCount] [varchar](50) NULL,
	[OfferLetter_Count] [varchar](50) NULL,
 CONSTRAINT [PK_Tbl_Acceptance_letter] PRIMARY KEY CLUSTERED 
(
	[Acceptence_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

