-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Event_Staff]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Event_Staff](
	[EventID] [bigint] NULL,
	[OtherStaff] [bigint] NULL

) ON [PRIMARY]
END

