-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Program_Duration]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Program_Duration](
	[Duration_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Program_Org_Id] [bigint] NULL,
	[Program_Category_Id] [bigint] NULL,
	[Program_Duration_Type] [varchar](10) NULL,
	[Program_Duration_Year] [float] NULL,
	[Program_Duration_Sem] [float] NULL,
	[Program_Duration_Month] [float] NULL,
	[Program_Duration_Days] [float] NULL,
	[Program_Duration_DelStatus] [bit] NULL,
	[Created_Date] [datetime] NULL,
	[Updated_date] [datetime] NULL,
	[Delete_Status] [bit] NULL,
 CONSTRAINT [PK_Tbl_Program_Duration] PRIMARY KEY CLUSTERED 
(
	[Duration_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

