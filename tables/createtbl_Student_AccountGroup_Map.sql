-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Student_AccountGroup_Map]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[tbl_Student_AccountGroup_Map](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[StudentID] [bigint] NULL,
	[FeeGroupID] [bigint] NULL,
	[FeeGroupCode] [varchar](50) NULL,
	[ProgrmID] [bigint] NULL,
	[programIntakeID] [bigint] NULL,
	[Promotion] [bit] NULL,
	[PromoPercentage] [decimal](18, 0) NULL,
	[StudType] [varchar](15) NULL,
	[deleteStatus] [bit] NULL,
	[createdDate] [datetime] NULL,
CONSTRAINT [PK_tbl_Student_AccountGroup_Map] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

