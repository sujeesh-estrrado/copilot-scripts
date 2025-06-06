-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Commission_Settings ]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Commission_Settings ](
	[Commission_Setting_Id] [bigint] IDENTITY(1,1) NOT NULL,
    [Course_Id] [bigint] NULL,
    [Fee_Code_Id] [bigint] NULL,
    [Feehead_Id] [bigint] NULL,
    [Commission_Amount] [decimal](18, 2) NULL,
    [EmpORAgent_Status] [bigint] NULL,
    [Employee_Id] [bigint] NULL,
    [Agent_ID] [bigint] NULL,
    [Delete_Status] [bit] NULL,
    [Remarks] [varchar](max) NULL,
    [ItemDescription] [varchar](200) NULL,
    [IntakeId] [bigint] NULL,
    [Created_Date] [datetime] NULL,
    [Updated_Date] [datetime] NULL,
    [Minimum_Amount] [decimal](18, 2) NULL,
 CONSTRAINT [PK_Tbl_Commission_Settings] PRIMARY KEY CLUSTERED 
(
    [Commission_Setting_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END


