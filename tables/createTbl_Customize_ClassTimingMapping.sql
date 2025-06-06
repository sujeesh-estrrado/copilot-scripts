-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Customize_ClassTimingMapping]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Customize_ClassTimingMapping](
	[Customize_ClassTimingMappingId] [bigint] IDENTITY(1,1) NOT NULL,
	[Customize_ClassTimingId] [bigint] NOT NULL,
	[Days_Id] [varchar](max) NOT NULL,
	[Batch_Id] [bigint] NOT NULL,
	[Department_Id] [bigint] NOT NULL,
	[Location_Id] [bigint] NULL,
	[Group_Id] [bigint] NOT NULL,
	[Group_Name] [varchar](max) NULL,
 CONSTRAINT [PK_Tbl_Customize_CallTimingMapping] PRIMARY KEY CLUSTERED 
(
	[Customize_ClassTimingMappingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

