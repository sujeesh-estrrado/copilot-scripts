-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Event_Details]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Event_Details](
	[Event_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[EventName] [varchar](max) NULL,
	[Agent] [varchar](max) NULL,
	[EventLeader] [bigint] NULL,
	[Inside_Outside] [varchar](max) NULL,
	[TypeOfEvent] [varchar](max) NULL,
	[International_or_Local] [varchar](max) NULL,
	[Start_Date] [date] NULL,
	[End_Date] [date] NULL,
	[Time] [varchar](max) NULL,
	[Country] [bigint] NULL,
	[State] [bigint] NULL,
	[City] [bigint] NULL,
	[EventVennu] [varchar](max) NULL,
	[BoothNo] [varchar](max) NULL,
	[BoothCount] [bigint] NULL,
	[TargetedStudent] [bigint] NULL,
	[OtherStaff] [bigint] NULL,
	[Del_status] [bigint] NULL,
	[MarketingMangerApproval_ID] [bigint] NULL,
	[PsoApproval_ID] [bigint] NULL,
	[DirectorApproval_ID] [bigint] NULL,
	[CreatedDate] [date] NULL,
	[ExpiredDate] [date] NULL,
	[Team_Id] [bigint] NULL,
 CONSTRAINT [PK_Tbl_Event_Details] PRIMARY KEY CLUSTERED 
(
	[Event_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

