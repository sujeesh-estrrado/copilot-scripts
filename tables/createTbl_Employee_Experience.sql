-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Employee_Experience]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Employee_Experience](
	[Employee_Experience_id] [bigint] IDENTITY(1,1) NOT NULL,
	[Employee_Experience_Pre_College_Name] [varchar](500) NULL,
	[Employee_Duration_From] [datetime] NULL,
	[Employee_Duration_To] [datetime] NULL,
	[Employee_Desigination] [varchar](50) NULL,
	[Employee_Experience_Status] [bit] NULL,
	[Employee_Id] [bigint] NULL,
 CONSTRAINT [PK_Tbl_Employee_Experience_1] PRIMARY KEY CLUSTERED 
(
	[Employee_Experience_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

