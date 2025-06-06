-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fee_group]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[fee_group](
		[groupid] [int] IDENTITY(1,1) NOT NULL,
		[groupname] [varchar](max) NULL,
		[description] [varchar](max) NULL,
		[programIntakeID] [bigint] NULL,
		[programid] [int] NULL,
		[totallocal] [float] NULL,
		[totalintl] [float] NULL,
		[type] [int] NULL,
		[datecreated] [datetime] NULL,
		[createdby] [int] NULL,
		[dateupdated] [datetime] NULL,
		[updatedby] [int] NULL,
		[active] [bit] NULL,
		[deleteStatus] [bit] NULL,
		[Promotional] [bit] NULL,
		[MinimumAmount] [decimal](18, 2) NULL,
		[MinAdmissionAmountInter] [decimal](18, 2) NULL,
		[MinAdmissionAmountLocal] [decimal](18, 2) NULL,
		CONSTRAINT [PK_fee_group] PRIMARY KEY CLUSTERED 
		(
		[groupid] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

