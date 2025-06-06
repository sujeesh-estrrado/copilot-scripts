-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Organzations]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Organzations](
	[Organization_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Organization_Name] [varchar](100) NULL,
	[Organization_Code] [varchar](50) NULL,
	[Organization_Address] [varchar](max) NULL,
	[Organization_Address2] [varchar](max) NULL,
	[Organization_Country] [varchar](100) NULL,
	[Organization_state] [varchar](100) NULL,
	[Organization_City] [varchar](100) NULL,
	[Organization_Pin] [varchar](10) NULL,
	[Organization_Website] [varchar](50) NULL,
	[Organization_Email] [varchar](50) NULL,
	[Organization_Phone] [varchar](20) NULL,
	[Organization_Mobile] [varchar](20) NULL,
	[Organization_Fax] [varchar](20) NULL,
	[Organization_GST_No] [varchar](20) NULL,
	[Organization_DelStatus] [bit] NOT NULL,
	[Color] [varchar](50) NULL,
	[Image_Path] [varchar](150) NULL,
	[Dashboard_Caption] [varchar](100) NULL,
	[odr] [varchar](50) NULL,
 CONSTRAINT [PK_Tbl_Organzations] PRIMARY KEY CLUSTERED 
(
	[Organization_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END


-- Insert data only if table exists and is empty
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Organzations]') AND type = N'U')
BEGIN
    IF NOT EXISTS (SELECT 1 FROM [dbo].[Tbl_Organzations])
    BEGIN

    SET IDENTITY_INSERT Tbl_Organzations ON;
        INSERT INTO [dbo].[Tbl_Organzations] ([Organization_Id], [Organization_Name], [Organization_Code], [Organization_Address], [Organization_Address2], [Organization_Country], [Organization_state], [Organization_City], [Organization_Pin], [Organization_Website], [Organization_Email], [Organization_Phone], [Organization_Mobile],[Organization_Fax],[Organization_GST_No],[Organization_DelStatus],[Color],[Image_Path],[Dashboard_Caption],[odr]) 
        VALUES 

(1, N'Organization', N'Refactoring', NULL, NULL,  NULL, NULL, NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL)
	SET IDENTITY_INSERT Tbl_Organzations OFF;
    END
END