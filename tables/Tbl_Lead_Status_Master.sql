-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Lead_Status_Master]') AND type = N'U')
BEGIN

CREATE TABLE [dbo].[Tbl_Lead_Status_Master](
	[Lead_Status_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Lead_Status_Name] [varchar](50) NOT NULL,
	[Lead_Status_DelStatus] [bit] NOT NULL,
	[Lead_Status_CreatedBy] [bigint] NULL,
	[Lead_Status_CreatedDate] [datetime] NULL,
	[Lead_Status_UpdateBy] [bigint] NULL,
	[Lead_Status_UpdatedDate] [datetime] NULL,
	[Lead_Status_DelDate] [datetime] NULL,
 CONSTRAINT [PK_Tbl_Lead_Status_Master] PRIMARY KEY CLUSTERED 
(
	[Lead_Status_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

-- Insert data only if the table exists and the records don't already exist
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[[Tbl_Lead_Status_Master]]]') AND type = N'U')
BEGIN
    IF NOT EXISTS (SELECT 1 FROM [dbo].[[Tbl_Lead_Status_Master]]])
    BEGIN
    	INSERT INTO [dbo].[[Tbl_Lead_Status_Master]]] ([Lead_Status_Name], [Lead_Status_DelStatus],[Lead_Status_CreatedBy],[Lead_Status_CreatedDate],[Lead_Status_UpdateBy],[Lead_Status_UpdatedDate],[Lead_Status_DelDate]) 
        VALUES 
        (N'Move to Application', 0,NULL,NULL,NULL,NULL,NULL),
        ( N'Rejected', 0,NULL,NULL,NULL,NULL,NULL)
     END
END
