IF NOT EXISTS (
    SELECT * 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Approval_Request]') 
      AND type = N'U'
)
BEGIN
    CREATE TABLE [dbo].[Approval_Request](
        [RequestId] [bigint] IDENTITY(1,1) NOT NULL,
        [RequestTypeId] [bigint] NULL,
        [StudentId] [bigint] NULL,
        [RequestDate] [datetime] NULL,
        [ApprovalStatus] [bigint] NULL,
        [RefundStatus] [bigint] NULL,
        [ApprovalBy] [bigint] NULL,
        [ApprovalDate] [datetime] NULL,
        [amount] [decimal](18, 2) NOT NULL,
        [FlagLedger] [varchar](10) NULL,
        CONSTRAINT [PK_Approval_Request] PRIMARY KEY CLUSTERED 
        (
            [RequestId] ASC
        )
        WITH (
            PAD_INDEX = OFF, 
            STATISTICS_NORECOMPUTE = OFF, 
            IGNORE_DUP_KEY = OFF, 
            ALLOW_ROW_LOCKS = ON, 
            ALLOW_PAGE_LOCKS = ON, 
            OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
        ) ON [PRIMARY]
    ) ON [PRIMARY];

    ALTER TABLE [dbo].[Approval_Request] 
        ADD CONSTRAINT [DF_Approval_Request_ApprovalStatus] DEFAULT ((1)) FOR [ApprovalStatus];

    ALTER TABLE [dbo].[Approval_Request] 
        ADD CONSTRAINT [DF_Approval_Request_amount] DEFAULT ((0)) FOR [amount];
END
