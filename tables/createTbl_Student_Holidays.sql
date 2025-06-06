-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Student_Holidays]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Student_Holidays](
	[Student_Holiday_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Student_Holiday_Name] [varchar](150) NULL,
	[Student_Holiday_FromDate] [datetime] NULL,
	[Student_Holiday_ToDate] [datetime] NULL,
	[Student_Holiday_Delete_Status] [bit] NULL,
CONSTRAINT [PK_Tbl_Student_Holidays] PRIMARY KEY CLUSTERED 
(
	[Student_Holiday_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

