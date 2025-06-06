-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_GradingScheme]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_GradingScheme](
	[Grade_Scheme_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Grade_Scheme] [varchar](50) NULL,
	[Description] [varchar](100) NULL,
	[MaxMark] [decimal](18, 2) NULL,
	[createdby] [bigint] NULL,
	[datecreated] [datetime] NULL,
	[updatedby] [bigint] NULL,
	[dateupdated] [datetime] NULL,
	[active] [bit] NULL,
	[Resit_Status] [bit] NULL,
 CONSTRAINT [PK_Tbl_GradingScheme] PRIMARY KEY CLUSTERED 
(
	[Grade_Scheme_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

