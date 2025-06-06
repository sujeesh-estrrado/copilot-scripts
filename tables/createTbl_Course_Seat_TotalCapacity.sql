-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Course_Seat_TotalCapacity]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Course_Seat_TotalCapacity](
	[totalCapacity_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Org_Id] [bigint] NULL,
	[Batch_Id] [bigint] NULL,
	[Category_Id] [bigint] NULL,
	[Department_Id] [bigint] NULL,
	[Total_Capacity] [int] NULL,
	[Created_Date] [datetime] NULL,
	[Updated_Date] [datetime] NULL,
	[Delete_Status] [bit] NULL,
 CONSTRAINT [PK_Tbl_Course_Seat_TotalCapacity] PRIMARY KEY CLUSTERED 
(
	[totalCapacity_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

