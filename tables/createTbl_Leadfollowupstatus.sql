-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Leadfollowupstatus]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Leadfollowupstatus](
	[Status_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Status] [varchar](max) NOT NULL,
	[Del_Status] [bigint] NOT NULL,
CONSTRAINT [PK_Tbl_Leadfollowupstatus] PRIMARY KEY CLUSTERED 
(
	[Status_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

