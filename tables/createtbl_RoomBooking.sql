-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_RoomBooking]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[tbl_RoomBooking](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Room] [bigint] NULL,
	[StartDateTime] [datetime] NULL,
	[StartTime] [time](7) NULL,
	[EndDateTime] [datetime] NULL,
	[EndTime] [time](7) NULL,
	[Description] [varchar](max) NULL,
	[SeatNos] [int] NULL,
	[RequestedBy] [bigint] NULL,
	[RequestedDate] [datetime] NULL,
	[ApprovalBy] [bigint] NULL,
	[ApprovalDate] [datetime] NULL,
	[ApprovalRemark] [varchar](max) NULL,
	[ApprovalStatus] [int] NULL,
	[RefType] [varchar](max) NULL,
	[RefID] [bigint] NULL,
 CONSTRAINT [PK_tbl_RoomBooking] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

