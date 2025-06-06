-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Employee_Education]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Employee_Education](
	[Employee_Education_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Employee_Degree] [varchar](250) NULL,
	[Employee_College] [varchar](250) NULL,
	[Employee_University] [varchar](250) NULL,
	[Employee_PassOutYear] [varchar](250) NULL,
	[Employee_PassOutMonth] [varchar](250) NULL,
	[Employee_Speciality] [varchar](250) NULL,
	[Employee_RegNo] [varchar](250) NULL,
	[Employee_RegDate] [varchar](250) NULL,
	[Employee_Education_State] [varchar](250) NULL,
	[Employee_Education_Status] [bit] NULL,
	[Employee_Id] [bigint] NULL,
	[Employee_Highest_Qualification] [bit] NOT NULL,
	[Employee_Programme] [varchar](max) NULL,
 CONSTRAINT [PK_Tbl_Employee_Experience] PRIMARY KEY CLUSTERED 
(
	[Employee_Education_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

