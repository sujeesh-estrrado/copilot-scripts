-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Temp_Agent]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Temp_Agent](
	[Temp_Agent_ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Temp_Agent_Category_Id] [bigint] NULL,
	[Temp_Agent_RegNo] [varchar](max) NULL,
	[Temp_Agent_Name] [varchar](max) NULL,
	[Temp_Agent_Home] [varchar](200) NULL,
	[Temp_Agent_Mob] [varchar](200) NULL,
	[Temp_Agent_Country_Id] [nchar](10) NULL,
	[Temp_Agent_Area] [varchar](max) NULL,
	[Temp_Agent_Email] [varchar](max) NULL,
	[Temp_Agent_Address] [varchar](max) NULL,
	[Temp_Agent_Location] [varchar](max) NULL,
	[Temp_Agent_Status] [varchar](max) NULL,
	[Temp_Nationality] [varchar](max) NULL,
	[Created_Date] [datetime] NULL,
	[Updated_Date] [datetime] NULL,
	[Delete_Status] [bit] NULL,
	[Temp_Counsellor_Id] [bigint] NULL,
	[PSO_Status] [bit] NULL,
	[Contract_Expiry] [datetime] NULL,
CONSTRAINT [PK_Tbl_Temp_Agent] PRIMARY KEY CLUSTERED 
(
	[Temp_Agent_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

