-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_FinancePrintlog]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_FinancePrintlog](
	[Print_LogID] [bigint] IDENTITY(1,1) NOT NULL,
	[Doc_Id] [bigint] NULL,
	[Printed_Date] [datetime] NULL,
	[Printed_By] [bigint] NULL,
CONSTRAINT [PK_Tbl_FinancePrintlog] PRIMARY KEY CLUSTERED 
(
	[Print_LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

