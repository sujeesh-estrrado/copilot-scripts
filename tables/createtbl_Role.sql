-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Role]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[tbl_Role](
	[role_Id] [int] IDENTITY(1,1) NOT NULL,
	[role_Name] [varchar](50) NULL,
	[role_status] [bit] NULL,
	[description] [varchar](max) NULL,
	[role_dtTime] [datetime] NULL,
	[role_DeleteStatus] [bit] NULL,
	[Is_Authority] [bit] NULL,
	[Is_PrimeAuthority] [bit] NULL,
	[Approval_limit_amount] [varchar](50) NULL,
	[static] [bit] NULL,
 CONSTRAINT [PK_tbl_Role] PRIMARY KEY CLUSTERED 
(
	[role_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

-- Insert data only if the table exists and is empty
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Role]') AND type = N'U')
BEGIN
    IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_Role] WHERE role_Name = 'admin')
    BEGIN
        INSERT INTO [dbo].[tbl_Role] ([role_Name], [role_status], [description], 
                                      [role_dtTime], [role_DeleteStatus], [Is_Authority], 
                                      [Is_PrimeAuthority], [Approval_limit_amount], [static]) 
        VALUES ('admin', 1, 'admin', NULL, 0, NULL, NULL, NULL, NULL)
    END

    IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_Role] WHERE role_Name = 'Employee')
    BEGIN
        INSERT INTO [dbo].[tbl_Role] ([role_Name], [role_status], [description], 
                                      [role_dtTime], [role_DeleteStatus], [Is_Authority], 
                                      [Is_PrimeAuthority], [Approval_limit_amount], [static]) 
        VALUES ('Employee', 1, 'Employee', NULL, 0, NULL, NULL, NULL, NULL)
    END
    IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_Role] WHERE role_Name = 'Faculty')
    BEGIN
        INSERT INTO [dbo].[tbl_Role] ([role_Name], [role_status], [description], 
                                      [role_dtTime], [role_DeleteStatus], [Is_Authority], 
                                      [Is_PrimeAuthority], [Approval_limit_amount], [static]) 
        VALUES ('Faculty', 1, 'Faculty', NULL, 0, NULL, NULL, NULL, NULL)
    END
    IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_Role] WHERE role_Name = 'Candidate')
    BEGIN
        INSERT INTO [dbo].[tbl_Role] ([role_Name], [role_status], [description], 
                                      [role_dtTime], [role_DeleteStatus], [Is_Authority], 
                                      [Is_PrimeAuthority], [Approval_limit_amount], [static]) 
        VALUES ('Candidate', 1, 'Candidate', NULL, 0, NULL, NULL, NULL, NULL)
    END
    IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_Role] WHERE role_Name = 'Student')
    BEGIN
        INSERT INTO [dbo].[tbl_Role] ([role_Name], [role_status], [description], 
                                      [role_dtTime], [role_DeleteStatus], [Is_Authority], 
                                      [Is_PrimeAuthority], [Approval_limit_amount], [static]) 
        VALUES ('Student', 1, 'Student', NULL, 0, NULL, NULL, NULL, NULL)
    END
    IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_Role] WHERE role_Name = 'Agent')
    BEGIN
        INSERT INTO [dbo].[tbl_Role] ([role_Name], [role_status], [description], 
                                      [role_dtTime], [role_DeleteStatus], [Is_Authority], 
                                      [Is_PrimeAuthority], [Approval_limit_amount], [static]) 
        VALUES ('Agent', 1, 'Agent', NULL, 0, NULL, NULL, NULL, NULL)
    END
    IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_Role] WHERE role_Name = 'Counsellor')
    BEGIN
        INSERT INTO [dbo].[tbl_Role] ([role_Name], [role_status], [description], 
                                      [role_dtTime], [role_DeleteStatus], [Is_Authority], 
                                      [Is_PrimeAuthority], [Approval_limit_amount], [static]) 
        VALUES ('Counsellor', 1, 'Counsellor', NULL, 0, NULL, NULL, NULL, NULL)
    END
    IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_Role] WHERE role_Name = 'Admission')
    BEGIN
        INSERT INTO [dbo].[tbl_Role] ([role_Name], [role_status], [description], 
                                      [role_dtTime], [role_DeleteStatus], [Is_Authority], 
                                      [Is_PrimeAuthority], [Approval_limit_amount], [static]) 
        VALUES ('Admission', 1, 'Admission', NULL, 0, NULL, NULL, NULL, NULL)
    END
     IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_Role] WHERE role_Name = 'Accountant')
    BEGIN
        INSERT INTO [dbo].[tbl_Role] ([role_Name], [role_status], [description], 
                                      [role_dtTime], [role_DeleteStatus], [Is_Authority], 
                                      [Is_PrimeAuthority], [Approval_limit_amount], [static]) 
        VALUES ('Accountant', 1, 'Accountant', NULL, 0, NULL, NULL, NULL, NULL)
    END
     IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_Role] WHERE role_Name = 'Registrar')
    BEGIN
        INSERT INTO [dbo].[tbl_Role] ([role_Name], [role_status], [description], 
                                      [role_dtTime], [role_DeleteStatus], [Is_Authority], 
                                      [Is_PrimeAuthority], [Approval_limit_amount], [static]) 
        VALUES ('Registrar', 1, 'Registrar', NULL, 0, NULL, NULL, NULL, NULL)
    END
     IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_Role] WHERE role_Name = 'FacultyDean')
    BEGIN
        INSERT INTO [dbo].[tbl_Role] ([role_Name], [role_status], [description], 
                                      [role_dtTime], [role_DeleteStatus], [Is_Authority], 
                                      [Is_PrimeAuthority], [Approval_limit_amount], [static]) 
        VALUES ('FacultyDean', 1, 'FacultyDean', NULL, 0, NULL, NULL, NULL, NULL)
    END
     IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_Role] WHERE role_Name = 'Finance')
    BEGIN
        INSERT INTO [dbo].[tbl_Role] ([role_Name], [role_status], [description], 
                                      [role_dtTime], [role_DeleteStatus], [Is_Authority], 
                                      [Is_PrimeAuthority], [Approval_limit_amount], [static]) 
        VALUES ('Finance', 1, 'Finance', NULL, 0, NULL, NULL, NULL, NULL)
    END
     IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_Role] WHERE role_Name = 'AdmissionHead')
    BEGIN
        INSERT INTO [dbo].[tbl_Role] ([role_Name], [role_status], [description], 
                                      [role_dtTime], [role_DeleteStatus], [Is_Authority], 
                                      [Is_PrimeAuthority], [Approval_limit_amount], [static]) 
        VALUES ('AdmissionHead', 1, 'AdmissionHead', NULL, 0, NULL, NULL, NULL, NULL)
    END
    IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_Role] WHERE role_Name = 'Counsellor Lead')
    BEGIN
        INSERT INTO [dbo].[tbl_Role] ([role_Name], [role_status], [description], 
                                      [role_dtTime], [role_DeleteStatus], [Is_Authority], 
                                      [Is_PrimeAuthority], [Approval_limit_amount], [static]) 
        VALUES ('Counsellor Lead', 1, 'Counsellor Lead', NULL, 0, NULL, NULL, NULL, NULL)
    END
    IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_Role] WHERE role_Name = 'Cashier')
    BEGIN
        INSERT INTO [dbo].[tbl_Role] ([role_Name], [role_status], [description], 
                                      [role_dtTime], [role_DeleteStatus], [Is_Authority], 
                                      [Is_PrimeAuthority], [Approval_limit_amount], [static]) 
        VALUES ('Cashier', 1, 'Cashier', NULL, 0, NULL, NULL, NULL, NULL)
    END
END
















