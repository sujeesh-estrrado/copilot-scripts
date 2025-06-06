-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Profile_View_control]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Profile_View_control](
	[View_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Role] [varchar](max) NULL,
	[Status] [bit] NULL,
	[Module] [varchar](max) NULL,
 CONSTRAINT [PK_Tbl_Profile_View_control] PRIMARY KEY CLUSTERED 
(
	[View_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

SET IDENTITY_INSERT [dbo].[Tbl_Profile_View_control] ON 

INSERT [dbo].[Tbl_Profile_View_control] ([View_Id], [Role], [Status], [Module]) VALUES (1, N'Marketing Manager', 1, N'Admission')
INSERT [dbo].[Tbl_Profile_View_control] ([View_Id], [Role], [Status], [Module]) VALUES (2, N'PSO', 1, N'Admission')
INSERT [dbo].[Tbl_Profile_View_control] ([View_Id], [Role], [Status], [Module]) VALUES (3, N'Admission', 1, N'Admission')
INSERT [dbo].[Tbl_Profile_View_control] ([View_Id], [Role], [Status], [Module]) VALUES (4, N'Admin', 1, N'Admission')
INSERT [dbo].[Tbl_Profile_View_control] ([View_Id], [Role], [Status], [Module]) VALUES (5, N'Counsellor', 1, N'Marketing')
INSERT [dbo].[Tbl_Profile_View_control] ([View_Id], [Role], [Status], [Module]) VALUES (6, N'Marketing Manager', 1, N'Marketing')
INSERT [dbo].[Tbl_Profile_View_control] ([View_Id], [Role], [Status], [Module]) VALUES (7, N'PSO', 1, N'Marketing')
INSERT [dbo].[Tbl_Profile_View_control] ([View_Id], [Role], [Status], [Module]) VALUES (8, N'Admin', 1, N'Marketing')
INSERT [dbo].[Tbl_Profile_View_control] ([View_Id], [Role], [Status], [Module]) VALUES (9, N'Agent', 1, N'Marketing')
INSERT [dbo].[Tbl_Profile_View_control] ([View_Id], [Role], [Status], [Module]) VALUES (10, N'Counsellor Lead', 1, N'Marketing')
INSERT [dbo].[Tbl_Profile_View_control] ([View_Id], [Role], [Status], [Module]) VALUES (11, N'Audit', 1, N'Marketing')
INSERT [dbo].[Tbl_Profile_View_control] ([View_Id], [Role], [Status], [Module]) VALUES (12, N'Faculty', 1, N'Marketing')
INSERT [dbo].[Tbl_Profile_View_control] ([View_Id], [Role], [Status], [Module]) VALUES (13, N'Faculty', 1, N'Admission')
INSERT [dbo].[Tbl_Profile_View_control] ([View_Id], [Role], [Status], [Module]) VALUES (14, N'Counsellor Lead', 1, N'Admission')
INSERT [dbo].[Tbl_Profile_View_control] ([View_Id], [Role], [Status], [Module]) VALUES (15, N'Admission', 1, N'Marketing')
SET IDENTITY_INSERT [dbo].[Tbl_Profile_View_control] OFF
END

