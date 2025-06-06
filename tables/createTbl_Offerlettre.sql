-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Offerlettre]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Offerlettre](
	[Offerletter_id] [bigint] IDENTITY(1,1) NOT NULL,
	[candidate_id] [bigint] NULL,
	[Offerletter_Path] [varchar](max) NULL,
	[Offerletter_type] [varchar](max) NULL,
	[Sented_by] [bigint] NULL,
	[Sentdate] [date] NULL,
	[created_date] [date] NULL,
	[update_date] [date] NULL,
	[delete_status] [bit] NULL,
	[Conditional_offerletter] [bit] NULL,
	[Resend_offerletter] [bit] NULL,
	[Template_id] [int] NULL,
 CONSTRAINT [PK_Tbl_Offerlettre] PRIMARY KEY CLUSTERED 
(
	[Offerletter_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

