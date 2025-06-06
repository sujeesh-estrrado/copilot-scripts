-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Course_Duration_Mapping]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Course_Duration_Mapping](
	[Duration_Mapping_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Org_Id] [bigint] NULL,
	[Duration_Period_Id] [bigint] NOT NULL,
	[Course_Department_Id] [bigint] NOT NULL,
	[Course_Department_Status] [bit] NOT NULL,
	[Created_Date] [datetime] NULL,
	[Updated_Date] [datetime] NULL,
	[Delete_Status] [bit] NULL,
 CONSTRAINT [PK_Tbl_Course_Duration_Mapping] PRIMARY KEY CLUSTERED 
(
	[Duration_Mapping_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

