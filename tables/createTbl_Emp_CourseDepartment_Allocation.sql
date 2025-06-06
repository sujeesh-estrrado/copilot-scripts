-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Emp_CourseDepartment_Allocation]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Emp_CourseDepartment_Allocation](
	[Emp_DepartmentAllocation_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Employee_Id] [bigint] NULL,
	[Allocated_CourseDepartment_Id] [bigint] NULL,
	[Emp_DepartmentAllocation_Status] [bit] NULL,
CONSTRAINT [PK_Tbl_Emp_CourseDepartment_Allocation] PRIMARY KEY CLUSTERED 
(
	[Emp_DepartmentAllocation_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

