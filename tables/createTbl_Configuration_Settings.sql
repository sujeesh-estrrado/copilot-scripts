-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Configuration_Settings]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Configuration_Settings](
	[Configuration_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Config_Type] [varchar](max) NULL,
	[Description] [varchar](max) NULL,
	[Config_Status] [bit] NULL,
	[Module] [varchar](200) NULL,
 CONSTRAINT [PK_Tbl_Configuration_Settings] PRIMARY KEY CLUSTERED 
(
	[Configuration_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
SET IDENTITY_INSERT [dbo].[Tbl_Configuration_Settings] ON 

INSERT [dbo].[Tbl_Configuration_Settings] ([Configuration_Id], [Config_Type], [Description], [Config_Status], [Module]) VALUES (1, N'AdmissionFeeMapping', N'Feemapping status', 1, N'Admission')
SET IDENTITY_INSERT [dbo].[Tbl_Configuration_Settings] OFF
END

