-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_FinanceUserRole]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[tbl_FinanceUserRole](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[RoleID] [bigint] NULL,
	[MenuID] [bigint] NULL,
	[status] [bit] NULL,
 CONSTRAINT [PK_tbl_FinanceUserRole] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END


-- Insert data only if the table exists and is empty
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_FinanceUserRole]') AND type = N'U')
BEGIN
    IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_FinanceUserRole])
    BEGIN
        INSERT INTO [dbo].[tbl_FinanceUserRole] ([RoleID], [MenuID], [status]) 
        VALUES (9, 1, 1),
        (9, 1, 1),(9, 2, 1),(9, 3, 1),(9, 4, 1),(9, 5, 1),(9, 6, 1),(9, 7, 1),(9, 8, 1),(9, 9, 1),(9, 10, 1),(9, 11, 1),(9, 12, 1),(9, 13, 1)
        (9, 14, 1),(9, 15, 1),(9, 16, 1),(9, 17, 1),(9, 18, 1),(9, 19, 1),(9, 20, 1),(9, 21, 1),(9, 22, 1),
        (1, 1, 1),(1, 2, 1),(1, 3, 1),(1, 4, 1),(1, 5, 1),(1, 6, 1),(1, 7, 1),(1, 8, 1),(1, 9, 1),(1, 10, 1),(1, 11, 1),(1, 12, 1),(1, 13, 1)
        (1, 14, 1),(1, 15, 1),(1, 16, 1),(1, 17, 1),(1, 18, 1),(1, 19, 1),(1, 20, 1),(1, 21, 1),(1, 22, 1)
    END
    
   
END