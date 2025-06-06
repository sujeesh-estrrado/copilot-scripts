-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Candidate_AirportPickup]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Candidate_AirportPickup](
	[AirportPickup_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[AirportPickup_Status] [bit] NULL,
	[Candidate_Id] [bigint] NULL,
	[Remarks] [varchar](max) NULL,
	[Employee_Id] [bigint] NULL,
	[Date] [date] NULL,
	[Time] [time](7) NULL,
	[Airport_From] [varchar](max) NULL,
	[Airport_To] [varchar](max) NULL,
	[Created_Date] [datetime] NULL,
	[Updated_Date] [datetime] NULL,
	[Delete_Status] [bit] NULL,
	 CONSTRAINT [PK_Tbl_Candidate_AirportPickup] PRIMARY KEY CLUSTERED 
(
	[AirportPickup_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

