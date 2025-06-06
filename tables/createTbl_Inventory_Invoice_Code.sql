-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Inventory_Invoice_Code]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Inventory_Invoice_Code](
	[Invoice_Code_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Invoice_Code_Name] [varchar](100) NOT NULL,
	[Invoice_Code_Prefix] [varchar](10) NULL,
	[Invoice_Code_StartNo] [bigint] NOT NULL,
	[Invoice_Code_Suffix] [varchar](5) NULL,
	[Invoice_Code_Current_Status] [bit] NOT NULL,
	[Invoice_Code_From_Date] [datetime] NOT NULL,
	[Invoice_Code_To_Date] [datetime] NOT NULL,
	[Invoice_Code_Del_Status] [bit] NOT NULL,
	[Admissionnoprefix] [varchar](50) NULL,
	[Prefix1] [varchar](10) NULL,
	[Prefix2] [varchar](10) NULL,
	[Prefix3] [varchar](10) NULL,
	[program_code] [varchar](10) NULL,
 CONSTRAINT [PK_Tbl_Inventory_Invoice_Code] PRIMARY KEY CLUSTERED 
(
	[Invoice_Code_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

