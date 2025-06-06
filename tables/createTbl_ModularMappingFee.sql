-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_ModularMappingFee]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_ModularMappingFee](
    [ModularMappingFeeId] [bigint] IDENTITY(1,1) NOT NULL,
    [ModularCourseID] [bigint] NOT NULL,
    [ModularMapFeeId] [bigint] NOT NULL,
    [FeeHeading] [varchar](500) NOT NULL,
    [Ischecked] [bit] NOT NULL,
    [DeleteStatus] [bigint] NOT NULL,
    [ModularCourseFee] [bigint] NULL,
 CONSTRAINT [PK_Tbl_ModularMappingFee] PRIMARY KEY CLUSTERED 
(
    [ModularMappingFeeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
