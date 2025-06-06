-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Quries]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Quries](
	[QueryID] [int] IDENTITY(1,1) NOT NULL,
	[Councellor_Id] [int] NULL,
	[Student_Id] [int] NULL,
	[Type] [varchar](50) NULL,
	[Message] [varchar](max) NULL,
	[date] [datetime] NULL,
	[ReplyMsg] [varchar](max) NULL,
	[replydate] [datetime] NULL,
	[Status] [varchar](50) NULL,
 CONSTRAINT [PK_Tbl_Quries] PRIMARY KEY CLUSTERED 
(
	[QueryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

