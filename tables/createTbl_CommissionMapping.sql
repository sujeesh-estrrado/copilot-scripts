-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_CommissionMapping]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_CommissionMapping](
	[Mapping_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Faculty_Id] [bigint] NULL,
	[Programme_Id] [bigint] NULL,
	[Intake_Id] [bigint] NULL,
	[Agent_Employee_Id] [bigint] NULL,
	[Type] [bigint] NULL,
	[Commission_Group_Id] [bigint] NULL,
	[Created_By] [bigint] NULL,
	[Updated_By] [bigint] NULL,
	[Created_Date] [datetime] NULL,
	[Updated_Date] [datetime] NULL,
	[Delete_Status] [bit] NULL,
	[ActiveStatus] [bit] NULL,
 CONSTRAINT [PK_Tbl_CommissionMapping] PRIMARY KEY CLUSTERED 
(
	[Mapping_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

