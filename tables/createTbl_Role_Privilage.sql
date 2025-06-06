-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Role_Privilage]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Role_Privilage](
	[Privilege_Id] [int] IDENTITY(1,1) NOT NULL,
	[role_Id] [int] NOT NULL,
	[Menu_Id] [int] NOT NULL,
	[Save_Status] [bit] NOT NULL,
	[Update_Status] [bit] NOT NULL,
	[Delete_Status] [bit] NOT NULL,
	[View_Status] [bit] NOT NULL,
 CONSTRAINT [PK_Tbl_Role_Privilage] PRIMARY KEY CLUSTERED 
(
	[Privilege_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

-- Insert data only if the table exists and is empty
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Role_Privilage]') AND type = N'U')
BEGIN
    -- Prevent duplicate inserts
    IF NOT EXISTS (SELECT 1 FROM [dbo].[Tbl_Role_Privilage] WHERE role_Id = 1 AND Menu_Id = 1)
    BEGIN
        INSERT INTO [dbo].[Tbl_Role_Privilage] ([role_Id], [Menu_Id], [Save_Status], 
                                                [Update_Status], [Delete_Status], [View_Status]) 
        VALUES (1, 1, 1, 1, 1, 1)
    END

    IF NOT EXISTS (SELECT 1 FROM [dbo].[Tbl_Role_Privilage] WHERE role_Id = 1 AND Menu_Id = 2)
    BEGIN
        INSERT INTO [dbo].[Tbl_Role_Privilage] ([role_Id], [Menu_Id], [Save_Status], 
                                                [Update_Status], [Delete_Status], [View_Status]) 
        VALUES (1, 2, 1, 1, 1, 1)
    END

    IF NOT EXISTS (SELECT 1 FROM [dbo].[Tbl_Role_Privilage] WHERE role_Id = 1 AND Menu_Id = 3)
    BEGIN
        INSERT INTO [dbo].[Tbl_Role_Privilage] ([role_Id], [Menu_Id], [Save_Status], 
                                                [Update_Status], [Delete_Status], [View_Status]) 
        VALUES (1, 3, 1, 1, 1, 1)
    END

    IF NOT EXISTS (SELECT 1 FROM [dbo].[Tbl_Role_Privilage] WHERE role_Id = 1 AND Menu_Id = 4)
    BEGIN
        INSERT INTO [dbo].[Tbl_Role_Privilage] ([role_Id], [Menu_Id], [Save_Status], 
                                                [Update_Status], [Delete_Status], [View_Status]) 
        VALUES (1, 4, 1, 1, 1, 1)
    END

    IF NOT EXISTS (SELECT 1 FROM [dbo].[Tbl_Role_Privilage] WHERE role_Id = 1 AND Menu_Id = 5)
    BEGIN
        INSERT INTO [dbo].[Tbl_Role_Privilage] ([role_Id], [Menu_Id], [Save_Status], 
                                                [Update_Status], [Delete_Status], [View_Status]) 
        VALUES (1, 5, 1, 1, 1, 1)
    END

    IF NOT EXISTS (SELECT 1 FROM [dbo].[Tbl_Role_Privilage] WHERE role_Id = 1 AND Menu_Id = 6)
    BEGIN
        INSERT INTO [dbo].[Tbl_Role_Privilage] ([role_Id], [Menu_Id], [Save_Status], 
                                                [Update_Status], [Delete_Status], [View_Status]) 
        VALUES (1, 6, 1, 1, 1, 1)
    END
    IF NOT EXISTS (SELECT 1 FROM [dbo].[Tbl_Role_Privilage] WHERE role_Id = 1 AND Menu_Id = 6)
    BEGIN
        INSERT INTO [dbo].[Tbl_Role_Privilage] ([role_Id], [Menu_Id], [Save_Status], 
                                                [Update_Status], [Delete_Status], [View_Status]) 
        VALUES (1, 7, 1, 1, 1, 1)
    END
END