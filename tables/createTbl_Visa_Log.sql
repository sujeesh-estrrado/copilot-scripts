-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Visa_Log]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Visa_Log](
	[Log_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Log_Details] [varchar](500) NOT NULL,
	[Candidate_Id] [bigint] NOT NULL,
	[Date] [date] NOT NULL,
	[Old] [varchar](100) NULL,
	[New] [varchar](100) NULL,
	[Changed_By] [bigint] NOT NULL,
 CONSTRAINT [PK_Tbl_Visa_Log] PRIMARY KEY CLUSTERED 
(
	[Log_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

