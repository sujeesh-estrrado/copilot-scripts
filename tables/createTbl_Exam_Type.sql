-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Exam_Type]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Exam_Type](
	[Exam_Type_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Exam_Type_Name] [varchar](100) NULL,
	[Exam_Type_Code] [varchar](50) NULL,
	[Exam_Type_Remarks] [varchar](300) NULL,
	[Exam_Type_DelStatus] [bit] NULL,
 CONSTRAINT [PK_Tbl_Exam_Type] PRIMARY KEY CLUSTERED 
(
	[Exam_Type_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

-- Insert data only if table exists and is empty
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Exam_Type]') AND type = N'U')
BEGIN
    IF NOT EXISTS (SELECT 1 FROM [dbo].[Tbl_Exam_Type])
    BEGIN
        INSERT INTO [dbo].[Tbl_Exam_Type] ([Exam_Type_Name]) 
        VALUES 
        (N'internal'),
        (N'Regular'),
        (N'Resit'),
        (N'Repeat'),
        (N'Practical')
    END
END