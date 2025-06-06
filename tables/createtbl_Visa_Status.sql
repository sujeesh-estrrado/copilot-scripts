-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Visa_Status]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[tbl_Visa_Status](
	[Visa_Status_Id] [int] IDENTITY(1,1) NOT NULL,
	[Status_Name] [varchar](20) NOT NULL,
	[Status_Value] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Visa_Status_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Status_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

-- Insert data only if the table exists and is empty
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Visa_Status]') AND type = N'U')
BEGIN
    IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_Visa_Status])
    BEGIN
        INSERT INTO [dbo].[tbl_Visa_Status] ([Status_Name], [Status_Value]) 
        VALUES 
        (N'Pending', 0),
        (N'Rejected', 0),
        (N'Approved', 0),
        (N'Applied', 0)
    END
END