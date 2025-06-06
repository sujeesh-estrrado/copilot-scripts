-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Employee_Allocations]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Employee_Allocations](
	[Faculty_Allocation_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Employee_Id] [bigint] NULL,
	[Allocation_From] [datetime] NULL,
	[Allocation_To] [datetime] NULL,
	[Room] [bigint] NULL,
	[Type] [varchar](500) NULL,
	[Reference_id] [bigint] NULL,
	[Status] [bigint] NULL,
 CONSTRAINT [PK_Tbl_Employee_Allocations] PRIMARY KEY CLUSTERED 
(
	[Faculty_Allocation_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

