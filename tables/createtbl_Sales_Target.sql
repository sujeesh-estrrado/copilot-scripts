-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Sales_Target]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[tbl_Sales_Target](
	[Target_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Councelor_Employee] [varchar](200) NULL,
	[Target_Year] [varchar](100) NULL,
	[Yearly_Target] [varchar](100) NULL,
	[Monthly_Target] [varchar](100) NULL,
	[Create_Date] [datetime] NULL,
	[DelStatus] [int] NULL,
 CONSTRAINT [PK_tbl_Sales_Target] PRIMARY KEY CLUSTERED 
(
	[Target_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

