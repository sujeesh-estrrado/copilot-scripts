-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Partner_University]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Partner_University](
	[Partner_UniversityId] [bigint] IDENTITY(1,1) NOT NULL,
	[University_Name] [varchar](max) NULL,
	[University_Code] [varchar](max) NULL,
	[delete_status] [bit] NULL,
	[Create_date] [datetime] NULL,
  CONSTRAINT [PK_Tbl_Partner_University] PRIMARY KEY CLUSTERED 
(
	[Partner_UniversityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

