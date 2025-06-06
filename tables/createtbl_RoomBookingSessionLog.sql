-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_RoomBookingSessionLog]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[tbl_RoomBookingSessionLog](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[BookingID] [bigint] NULL,
	[Room] [bigint] NULL,
	[RoomBookingDate] [date] NULL,
	[Seats] [bigint] NULL,
	[Session] [int] NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK_tbl_RoomBooingSessionLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

