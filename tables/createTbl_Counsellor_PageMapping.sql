-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Counsellor_PageMapping]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Counsellor_PageMapping](
	[PageMapping_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Counsellor_Id] [bigint] NULL,
	[Page_Id] [bigint] NULL,
	[Created_By] [bigint] NULL,
	[created_Date] [datetime] NULL,
	[Updated_Date] [datetime] NULL,
	[Counter] [bigint] NULL,
	[Delete_Status] [bit] NULL,
	[InstapageURL_Id] [bigint] NULL,
	[Nationality_Id] [bigint] NULL,
	[state_id] [int] NULL,
	[Program_id] [int] NULL,
	[Agent_id] [int] NULL,
	[Type] [varchar](25) NULL,
	[ActiveStatus] [int] NULL,
 CONSTRAINT [PK_Tbl_Counsellor_PageMapping] PRIMARY KEY CLUSTERED 
(
	[PageMapping_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

