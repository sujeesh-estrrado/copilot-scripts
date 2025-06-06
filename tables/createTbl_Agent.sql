-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Agent]') AND type = N'U')
BEGIN
	CREATE TABLE [dbo].[Tbl_Agent](
	[Agent_ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Agent_Category_Id] [bigint] NULL,
	[Agent_RegNo] [varchar](max) NULL,
	[Agent_Name] [varchar](max) NULL,
	[Agent_Home] [varchar](200) NULL,
	[Agent_Mob] [varchar](200) NULL,
	[Agent_Country_Id] [nchar](10) NULL,
	[Agent_Area] [varchar](max) NULL,
	[Agent_Email] [varchar](max) NULL,
	[Agent_Address] [varchar](max) NULL,
	[Agent_Location] [varchar](max) NULL,
	[Agent_Status] [varchar](max) NULL,
	[Nationality] [varchar](max) NULL,
	[Created_Date] [datetime] NULL,
	[Updated_Date] [datetime] NULL,
	[Delete_Status] [bit] NULL,
	[Counsellor_Id] [bigint] NULL,
	[PSO_Status] [bit] NULL,
	[Contract_Expiry] [datetime] NULL,
	CONSTRAINT [PK_Tbl_Agent] PRIMARY KEY CLUSTERED 
(
	[Agent_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

