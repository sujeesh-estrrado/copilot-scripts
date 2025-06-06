-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_ModularCourseMapFee]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_ModularCourseMapFee](
    [MapFeeID] [bigint] IDENTITY(1,1) NOT NULL,
    [ModularCourseID] [bigint] NOT NULL,
    [ModularCourseFee] [decimal](18, 2) NOT NULL,
    [FeeHeading] [varchar](500) NOT NULL,
    [Ischecked] [bit] NOT NULL,
    [DeleteStatus] [bigint] NOT NULL,
 CONSTRAINT [PK_Tbl_MapFee] PRIMARY KEY CLUSTERED 
(
    [MapFeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
