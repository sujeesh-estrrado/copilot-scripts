-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Agent_Category]') AND type = N'U')
BEGIN
	CREATE TABLE [dbo].[Tbl_Agent_Category](
	[Category_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Category_Name] [varchar](max) NULL,
	[Commission_Rate] [bigint] NULL,
	[Active_Status] [varchar](max) NULL,
	[Created_Date] [datetime] NULL,
	[Updated_Date] [datetime] NULL,
	[Delete_Status] [bit] NULL,
  CONSTRAINT [PK_Tbl_Agent_Category] PRIMARY KEY CLUSTERED 
(
	[Category_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

-- Insert default data only if table exists and is empty
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Agent_Category]') AND type = N'U')
BEGIN
	IF NOT EXISTS (SELECT 1 FROM [dbo].[Tbl_Agent_Category])
	BEGIN
		INSERT INTO [dbo].[Tbl_Agent_Category] ([Category_Name], [Commission_Rate], [Active_Status], [Created_Date], [Updated_Date], [Delete_Status])
		VALUES 
			('Local Agents', NULL, 'Active', GETDATE(), NULL, 0),
			('International Agents', NULL, 'Active', GETDATE(), NULL, 0)
	END
END