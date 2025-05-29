-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Counsilor_Custom_Filter]') AND type = N'U')
BEGIN

CREATE TABLE [dbo].[tbl_Counsilor_Custom_Filter](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[CounselorEmployeeId] [bigint] NOT NULL,
	[TabName] [varchar](255) NOT NULL,
	[Faculty] [bigint] NULL,
	[Programme] [bigint] NULL,
	[Batch] [bigint] NULL,
	[DeleteStatus] [bigint] NOT NULL,
	[Dashboard] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbl_Counsilor_Custom_Filter] ADD  DEFAULT ((0)) FOR [DeleteStatus]
END

