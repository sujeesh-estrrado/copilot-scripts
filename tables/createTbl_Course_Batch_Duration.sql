-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Course_Batch_Duration]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Course_Batch_Duration](
[Batch_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Org_Id] [bigint] NULL,
	[IntakeMasterID] [bigint] NULL,
	[Duration_Id] [bigint] NULL,
	[intake_no] [varchar](50) NULL,
	[intake_month] [varchar](50) NULL,
	[intake_year] [varchar](50) NULL,
	[localdepo] [varchar](50) NULL,
	[interdepo] [varchar](50) NULL,
	[dateregsatart] [date] NULL,
	[dateregend] [date] NULL,
	[timestart] [time](7) NULL,
	[timeend] [time](7) NULL,
	[venue] [varchar](500) NULL,
	[lastnumber] [bigint] NULL,
	[created_by] [bigint] NULL,
	[Batch_Code] [varchar](100) NULL,
	[Batch_From] [datetime] NULL,
	[Batch_To] [datetime] NULL,
	[Batch_DelStatus] [bit] NULL,
	[Study_Mode] [varchar](50) NULL,
	[Intro_Date] [datetime] NULL,
	[Close_Date] [datetime] NULL,
	[SyllubusCode] [varchar](50) NULL,
	[create_date] [datetime] NULL,
	[updated_by] [bigint] NULL,
	[updated_date] [datetime] NULL,
 CONSTRAINT [PK_Tbl_Course_Batch_Duration] PRIMARY KEY CLUSTERED 
(
	[Batch_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

