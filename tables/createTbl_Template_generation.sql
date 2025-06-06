-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Template_generation]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Template_generation](
	[Template_id] [bigint] IDENTITY(1,1) NOT NULL,
	[Template_name] [varchar](500) NULL,
	[Html_Url] [varchar](500) NULL,
	[code] [varchar](max) NULL,
	[module] [varchar](50) NULL,
	[created_date] [date] NULL,
	[Created_by] [bigint] NULL,
	[updated_date] [date] NULL,
	[updatedby] [bigint] NULL,
	[delete_status] [bit] NULL,
	[active] [bit] NULL,
 CONSTRAINT [PK_Tbl_Template_generation] PRIMARY KEY CLUSTERED 
(
	[Template_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

