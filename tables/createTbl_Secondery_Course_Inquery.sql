-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Secondery_Course_Inquery]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Secondery_Course_Inquery](
	[Second_Inquiry_id] [bigint] IDENTITY(1,1) NOT NULL,
	[Candidate_id] [bigint] NULL,
	[Course_id] [bigint] NULL,
	[status] [varchar](50) NULL,
	[Create_date] [datetime] NULL,
	[Update_date] [datetime] NULL,
	[delete_status] [bit] NULL,
 CONSTRAINT [PK_Tbl_Secondery_Course_Inquery] PRIMARY KEY CLUSTERED 
(
	[Second_Inquiry_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

