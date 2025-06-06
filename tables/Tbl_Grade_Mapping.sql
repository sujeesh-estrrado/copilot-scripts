-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Grade_Mapping]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Grade_Mapping](
	[Emp_Grade_Mapping_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Emp_Grade_Id] [bigint] NULL,
	[Emp_Grade_From_Date] [varchar](50) NULL,
	[Emp_Grade_To_Date] [varchar](50) NULL,
	[Employee_Id] [bigint] NULL,
	[Emp_Grade_Mapping_Status] [bit] NULL,
	[Dept_Designation_Id] [bigint] NULL,
  CONSTRAINT [PK_Tbl_Grade_Mapping] PRIMARY KEY CLUSTERED 
(
	[Emp_Grade_Mapping_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

