-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_ExceptionLoggingToDataBase]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_ExceptionLoggingToDataBase](
	[Logid] [bigint] IDENTITY(1,1) NOT NULL,
	[ExceptionMsg] [varchar](max) NULL,
	[ExceptionType] [varchar](100) NULL,
	[ExceptionSource] [nvarchar](max) NULL,
	[ExceptionURL] [varchar](100) NULL,
	[Logdate] [datetime] NULL,
	[AdditionalInfo] [varchar](max) NULL,
 CONSTRAINT [PK_Tbl_ExceptionLoggingToDataBase] PRIMARY KEY CLUSTERED 
(
	[Logid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

