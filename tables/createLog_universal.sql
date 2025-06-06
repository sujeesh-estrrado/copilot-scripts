-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[log_universal]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[log_universal](
	[logid] [bigint] IDENTITY(1,1) NOT NULL,
	[staffid] [bigint] NULL,
	[datelog] [datetime] NULL,
	[action] [varchar](max) NULL,
	[studentid] [bigint] NULL,
	[oldrecord] [varchar](max) NULL,
	[newrecord] [varchar](max) NULL,
	[actionurl] [varchar](max) NULL,
	[description] [varchar](max) NULL,
	[oldcounsellor] [bigint] NULL,
	[oldagent] [bigint] NULL,
	[oldother] [varchar](max) NULL,
	[newcounsellor] [bigint] NULL,
	[newagent] [bigint] NULL,
	[newother] [varchar](max) NULL,
 CONSTRAINT [PK_log_universal] PRIMARY KEY CLUSTERED 
(
	[logid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

