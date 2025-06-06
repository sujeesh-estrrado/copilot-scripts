-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Emp_Intake_Program_Course_Mapping]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Emp_Intake_Program_Course_Mapping](
	[EmployeeSubjectMapping_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Employee_Id] [bigint] NULL,
	[Course_Department_Id] [bigint] NULL,
	[Batch_Id] [bigint] NULL,
	[Subject_Id] [varchar](max) NULL,
	[Del_Status] [bit] NULL,
	[Location_Id] [bigint] NULL,
	[Emp_DepartmentAllocation_Id] [int] NOT NULL,
CONSTRAINT [PK_Tbl_Emp_Subject_Allocation] PRIMARY KEY CLUSTERED 
(
	[EmployeeSubjectMapping_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

