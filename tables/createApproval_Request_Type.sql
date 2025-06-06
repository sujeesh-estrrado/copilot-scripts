-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Approval_Request_Type]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Approval_Request_Type](
		[Id] [bigint] IDENTITY(1,1) NOT NULL,
		[Types] [varchar](50) NULL,
		CONSTRAINT [PK_Approval_Request_Type] PRIMARY KEY CLUSTERED 
		(
		[Id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Approval_Request_Type]') AND type = N'U')
BEGIN
    IF NOT EXISTS (SELECT 1 FROM [dbo].[Approval_Request_Type])
    BEGIN
        INSERT INTO [dbo].[Approval_Request_Type] ([Types]) 
        VALUES 
        (N'Payment'),
        (N'Refund'),
        (N'Installment'),
        (N'Withdraw'),
        (N'Defer'),
        (N'Termination'),
        (N'OnlinePayment'),
        (N'CheckPoint Skip'),
        (N'Docket Skip'),
        (N'Visa'),
        (N'Course Registration')
    END
END