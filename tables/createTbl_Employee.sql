-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Employee]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Employee](
	[Employee_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Employee_FName] [varchar](500) NULL,
	[Employee_LName] [varchar](50) NULL,
	[Employee_DOB] [datetime] NULL,
	[Employee_Gender] [varchar](50) NULL,
	[Employee_Permanent_Address] [varchar](250) NULL,
	[Employee_Permanent_Address2] [varchar](500) NULL,
	[Employee_Present_Address] [varchar](250) NULL,
	[Employee_Phone] [varchar](50) NULL,
	[Employee_Mail] [varchar](50) NULL,
	[Employee_Mobile] [varchar](50) NULL,
	[Employee_Martial_Status] [varchar](50) NULL,
	[Blood_Group] [varchar](20) NULL,
	[Employee_Id_Card_No] [varchar](20) NULL,
	[Employee_Nationality] [varchar](max) NULL,
	[Employee_Country] [varchar](max) NULL,
	[Employee_State] [varchar](max) NULL,
	[Employee_City] [varchar](max) NULL,
	[Employee_postcode] [varchar](50) NULL,
	[Employee_Experience_If_Any] [varchar](500) NULL,
	[Employee_Father_Name] [varchar](50) NULL,
	[Employee_Nominee_Name] [varchar](50) NULL,
	[Employee_Nominee_Relation] [varchar](50) NULL,
	[Employee_Nominee_Phone] [varchar](50) NULL,
	[Employee_Nominee_Address] [varchar](500) NULL,
	[Employee_Status] [bit] NULL,
	[Employee_Type] [varchar](50) NULL,
	[Employee_Img] [varchar](max) NULL,
	[Employee_Aadhar] [varchar](30) NULL,
	[Identification_No] [varchar](50) NULL,
	[Spouse_FName] [varchar](max) NULL,
	[Spouse_LName] [varchar](max) NULL,
	[Spouse_IC_No] [varchar](max) NULL,
	[NoofChildren] [varchar](max) NULL,
	[Spouse_Email] [varchar](max) NULL,
	[Spouse_MobileNo] [varchar](15) NULL,
	[Emergency_Name] [varchar](200) NULL,
	[Emergency_Number] [varchar](max) NULL,
	[Organisation_id] [bigint] NULL,
	[Counselor_Type] [varchar](max) NULL,
	[Lead_assigned_date] [datetime] NULL,
	[Active_Status] [varchar](10) NULL,
 CONSTRAINT [PK_Tbl_Employee] PRIMARY KEY CLUSTERED 
(
	[Employee_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Employee]') AND type = N'U')
BEGIN
    IF NOT EXISTS (SELECT 1 FROM [dbo].[Tbl_Employee])
    BEGIN
        INSERT INTO [dbo].[Tbl_Employee] (
            [Employee_FName], [Employee_LName], [Employee_DOB], [Employee_Gender],
            [Employee_Permanent_Address], [Employee_Permanent_Address2], [Employee_Present_Address],
            [Employee_Phone], [Employee_Mail], [Employee_Mobile], [Employee_Martial_Status],
            [Blood_Group], [Employee_Id_Card_No], [Employee_Nationality], [Employee_Country],
            [Employee_State], [Employee_City], [Employee_postcode], [Employee_Experience_If_Any],
            [Employee_Father_Name], [Employee_Nominee_Name], [Employee_Nominee_Relation],
            [Employee_Nominee_Phone], [Employee_Nominee_Address], [Employee_Status], [Employee_Type],
            [Employee_Img], [Employee_Aadhar], [Identification_No], [Spouse_FName], [Spouse_LName],
            [Spouse_IC_No], [NoofChildren], [Spouse_Email], [Spouse_MobileNo], [Emergency_Name],
            [Emergency_Number], [Organisation_id], [Counselor_Type], [Lead_assigned_date], [Active_Status]
        ) 
        VALUES (
            'John', 'Doe', '1990-01-01', 'Male',
            '123 Main St', 'Suite 100', '456 Elm St',
            '0123456789', 'john.doe@example.com', '0987654321', 'Single',
            'O+', 'ID123456', 'Malaysian', 0,
            0, 0, '90001', '5 years as Software Engineer',
            'Richard Doe', 'Jane Doe', 'Sister',
            '0123456789', '789 Oak St', 1, 'Teaching',
            'image.jpg', 'AADHAR123456', 'IDNO123456', 'Jane', 'Doe',
            'IC987654', '2', 'jane.doe@example.com', '0912345678', 'Emily Doe',
            '0900123456', 1, 'Senior Counselor', GETDATE(), 'Active'
        )
    END
END
