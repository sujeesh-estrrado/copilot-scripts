-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_ExamseatLayout]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_ExamseatLayout](
	[Seat_Arrange_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Exam_Id] [bigint] NULL,
	[Venue] [bigint] NULL,
	[SeatNo] [bigint] NULL,
	[StudentId] [bigint] NULL,
	[FromTime] [datetime] NULL,
	[ToTime] [datetime] NULL,
	[Created_By] [bigint] NULL,
	[Created_Date] [datetime] NULL,
	[Updated_Date] [datetime] NULL,
	[Delete_Status] [bit] NULL,
 CONSTRAINT [PK_Tbl_ExamseatLayout] PRIMARY KEY CLUSTERED 
(
	[Seat_Arrange_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

