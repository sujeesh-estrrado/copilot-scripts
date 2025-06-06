-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_CommissionGroup]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_CommissionGroup](
	[Commission_GroupId] [bigint] IDENTITY(1,1) NOT NULL,
	[GroupName] [varchar](max) NULL,
	[FacultyId] [bigint] NULL,
	[ProgrammeId] [bigint] NULL,
	[IntakeId] [bigint] NULL,
	[International_Amount] [decimal](18, 2) NULL,
	[Local_Amount] [decimal](18, 2) NULL,
	[Created_By] [bigint] NULL,
	[Updated_By] [bigint] NULL,
	[Created_Date] [datetime] NULL,
	[Updated_Date] [datetime] NULL,
	[Delete_Status] [bit] NULL,
	[ActiveStatus] [bit] NULL,
	[GroupType] [bigint] NULL,
 CONSTRAINT [PK_Tbl_CommissionGroup] PRIMARY KEY CLUSTERED 
(
	[Commission_GroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

