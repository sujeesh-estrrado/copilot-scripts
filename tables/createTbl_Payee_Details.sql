-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Payee_Details]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Payee_Details](
	[Details_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Payee_Id] [bigint] NULL,
	[PayeeName] [varchar](max) NULL,
	[BankAcNo] [varchar](max) NULL,
	[BankTelephoneNo] [varchar](max) NULL,
	[swiftcode] [varchar](max) NULL,
	[BankAddress] [varchar](max) NULL,
	[Created_By] [bigint] NULL,
	[Updated_By] [bigint] NULL,
	[Created_Date] [datetime] NULL,
	[Updated_Date] [datetime] NULL,
	[Delete_Status] [bit] NULL,
	[Active_Status] [bit] NULL,
 CONSTRAINT [PK_Tbl_Payee_Details] PRIMARY KEY CLUSTERED 
(
	[Details_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

