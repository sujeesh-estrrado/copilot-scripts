-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_ExamseatNumber]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_ExamseatNumber](
	[SeatNoId] [bigint] IDENTITY(1,1) NOT NULL,
	[SeatNo] [nvarchar](50) NULL,
	[Room_Id] [bigint] NULL,
	[Delete_Status] [bit] NULL,
 CONSTRAINT [PK_Tbl_ExamseatNumber] PRIMARY KEY CLUSTERED 
(
	[SeatNoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

