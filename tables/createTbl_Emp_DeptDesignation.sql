-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Emp_DeptDesignation]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Emp_DeptDesignation](
	[Dept_Designation_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Dept_Designation_Name] [varchar](255) NULL,
	[desicription] [varchar](max) NULL,
	[code] [varchar](50) NULL,
	[Dept_Designation_Status] [bit] NULL,
	[Created_Date] [datetime] NULL,
	[Updated_Date] [datetime] NULL,
	[Delete_Status] [bit] NULL,
	[createdby] [bigint] NULL,
 CONSTRAINT [PK_Tbl_Emp_Designation] PRIMARY KEY CLUSTERED 
(
	[Dept_Designation_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

