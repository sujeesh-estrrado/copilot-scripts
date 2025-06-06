-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fee_group_item]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[fee_group_item](
		[groupitemid] [bigint] IDENTITY(1,1) NOT NULL,
		[accountcodeid] [bigint] NULL,
		[itemname] [varchar](250) NULL,
		[amountlocal] [float] NULL,
		[amountintl] [float] NULL,
		[remarks] [varchar](255) NULL,
		[groupid] [bigint] NULL,
		[semester] [int] NULL,
		[datecreated] [datetime] NULL,
		[createdby] [bigint] NULL,
		[dateupdated] [datetime] NULL,
		[updatedby] [bigint] NULL,
		[deleteStatus] [bit] NULL,
		CONSTRAINT [PK_fee_group_item] PRIMARY KEY CLUSTERED 
		(
		[groupitemid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]
END

