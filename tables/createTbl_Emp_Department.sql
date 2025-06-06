-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Emp_Department]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Emp_Department](
	[Dept_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[code] [varchar](50) NULL,
	[Dept_Name] [varchar](255) NULL,
	[Dept_ShortName] [varchar](255) NULL,
	[Parent_Dept] [bigint] NULL,
	[Dept_Head] [varchar](255) NULL,
	[Dept_Status] [bit] NULL,
	[Dept_Signature] [varchar](255) NULL,
	[Created_Date] [datetime] NULL,
	[Updated_Date] [datetime] NULL,
	[Delete_Status] [bit] NULL,
CONSTRAINT [PK_Tbl_Emp_Department] PRIMARY KEY CLUSTERED 
(
	[Dept_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

