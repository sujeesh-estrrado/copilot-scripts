-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Particulars_detailss]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Particulars_detailss](
	[Event_ID] [bigint] NULL,
	[Employee_Id] [bigint] NULL,
	[Particulars] [varchar](50) NULL,
	[Budget] [decimal](18, 2) NULL,
	[Del_status] [bigint] NULL,
	[ActualExpense] [decimal](18, 2) NULL,
	[DocumentName] [varchar](200) NULL,
	[DocumentLoc] [varchar](max) NULL

) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

