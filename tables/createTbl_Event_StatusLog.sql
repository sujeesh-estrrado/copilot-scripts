-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Event_StatusLog]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Event_StatusLog](
	[Event_Id] [bigint] NULL,
	[Employee_Id] [bigint] NULL,
	[Action_Date] [date] NULL,
	[Status] [varchar](max) NULL,
	[Remark] [varchar](max) NULL

)ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

