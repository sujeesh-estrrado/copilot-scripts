-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Visa_Renewal]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Visa_Renewal](
	[Candidate_Id] [bigint] NOT NULL,
	[Applied_Date] [datetime] NULL,
	[Remark] [varchar](500) NULL,
	[Registrar_Approval] [bigint] NULL,
	[Finance_Approval] [bigint] NULL,
	[Del_Status] [int] NULL,
	[Visa_Renewal_Id] [int] IDENTITY(1,1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Visa_Renewal_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

