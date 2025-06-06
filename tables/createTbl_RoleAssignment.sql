-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_RoleAssignment]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_RoleAssignment](
	[Emp_RoleAssignId] [bigint] IDENTITY(1,1) NOT NULL,
	[employee_id] [bigint] NOT NULL,
	[role_id] [int] NOT NULL,
	[del_Status] [bit] NULL,
	[User_ID] [int] NULL,
 CONSTRAINT [PK_Tbl_RoleAssignment] PRIMARY KEY CLUSTERED 
(
	[Emp_RoleAssignId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

