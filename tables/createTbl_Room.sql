-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Room]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Room](
	[Room_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Room_Name] [varchar](200) NOT NULL,
	[Campus_Id] [bigint] NOT NULL,
	[Block_Id] [bigint] NOT NULL,
	[Floor_Id] [bigint] NOT NULL,
	[Seat_Capacity] [int] NOT NULL,
	[Exam_SeatCapacity] [int] NOT NULL,
	[Room_Status] [bit] NOT NULL,
	[Room_Type] [bigint] NULL,
  CONSTRAINT [PK_Tbl_Room] PRIMARY KEY CLUSTERED 
(
	[Room_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

