-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_EmployeeActionLog]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[tbl_EmployeeActionLog](
	[LogID] [bigint] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [bigint] NULL,
	[Description] [varchar](max) NULL,
	[RefID] [bigint] NULL,
	[LDate] [datetime] NULL,
	[Type] [varchar](max) NULL,
 CONSTRAINT [PK_tbl_EmployeeActionLog] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

