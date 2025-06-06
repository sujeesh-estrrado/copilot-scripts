-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Emp_Queries]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Emp_Queries](
	[Query_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Employee_Id] [bigint] NOT NULL,
	[Type] [varchar](50) NULL,
	[Message] [varchar](500) NULL,
	[Date] [datetime] NULL,
	[ReplyMsg] [varchar](500) NULL,
	[ReplyDate] [datetime] NULL,
	[Status] [varchar](50) NULL,
	[Councellor_Id] [bigint] NULL,
 CONSTRAINT [PK_Tbl_Emp_Queries] PRIMARY KEY CLUSTERED 
(
	[Query_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

