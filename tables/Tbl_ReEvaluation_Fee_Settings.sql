-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_ReEvaluation_Fee_Settings]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_ReEvaluation_Fee_Settings](
	[Fee_Settings_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ReEvaluation_Fee_Master_Id] [bigint] NULL,
	[Course_Id] [bigint] NULL,
	[Fee_Amount] [decimal](8, 2) NOT NULL,
	[Created_By] [bigint] NULL,
	[Created_date] [datetime] NULL,
	[Updated_Date] [datetime] NULL,
	[Delete_Status] [bit] NULL,
 CONSTRAINT [PK_Tbl_ReEvaluation_Fee_Settings] PRIMARY KEY CLUSTERED 
(
	[Fee_Settings_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

