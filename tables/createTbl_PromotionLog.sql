-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_PromotionLog]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_PromotionLog](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Promotedby] [bigint] NULL,
	[Promotion_date] [date] NULL,
	[DeleteStatus] [bit] NULL,
 CONSTRAINT [PK_Tbl_PromotionLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

