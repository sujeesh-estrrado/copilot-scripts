-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fixed_payment_method]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[fixed_payment_method](
		[id] [int] IDENTITY(1,1) NOT NULL,
		[code] [int] NULL,
		[name] [varchar](150) NULL,
		[description] [varchar](150) NULL,
		[odr] [int] NULL,
		[active] [int] NULL,
		[paySupports] [varchar](max) NULL,
		CONSTRAINT [PK_fixed_payment_method] PRIMARY KEY CLUSTERED 
		(
		[id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

-- Insert data only if table exists and is empty
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fixed_payment_method]') AND type = N'U')
BEGIN
    IF NOT EXISTS (SELECT 1 FROM [dbo].[fixed_payment_method])
    BEGIN
        INSERT INTO [dbo].[fixed_payment_method] ([code], [name], [description], [odr], [active], [paySupports]) 
        VALUES 
        (0, N'Cash', N'cash', 100, 1, N'1,2,3,4,5'),
        (0, N'Telegraphic Transfer.', N'Telegraphic Transfer', 100, 1, N'1,2,3,4,5'),
        (0, N'Master Card', N'Master Card', 100, 1, N'1,2,3,4,5'),
        (0, N'AMEX', N'AMEX', 100, 1, N'1,2,3,4,5'),
        (0, N'Visa', N'Visa', 100, 1, N'1,2,3,4,5'),
        (0, N'Bank-in Slip', N'Bankin Slip', 100, 1, N'1,2,3,4,5'),
        (0, N'QR Code', N'QR', 100, 1, N'1,2,3,4,5'),
        (0, N'Online', N'Online Payment', 100, 1, N'1,2,3,4,5'),
        (0, N'UPI ID', N'Using UPI ID', 100, 1, N'1,2,3,4,5')
    END
END