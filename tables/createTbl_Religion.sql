-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Religion]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Religion](
	[Religion_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Religion] [varchar](100) NULL,
CONSTRAINT [PK_tblReligion] PRIMARY KEY CLUSTERED 
(
	[Religion_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

-- Insert data only if the table exists and is empty
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Religion]') AND type = N'U')
BEGIN
    IF NOT EXISTS (SELECT 1 FROM [dbo].[Tbl_Religion])
    BEGIN
        INSERT INTO [dbo].[Tbl_Religion] ([Religion]) 
        VALUES 
        (N'Islam'),
        (N'Buddhism'),
        (N'Christian'),
        (N'Hinduism'),
        (N'Sikhism'),
        (N'Others')
    END
END