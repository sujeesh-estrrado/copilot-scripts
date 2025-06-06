-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_FinanceAccessMaster]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[tbl_FinanceAccessMaster](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[FinanceAccess] [varchar](max) NULL,
	[Type] [bigint] NULL,
CONSTRAINT [PK_tbl_FinanaceAccessMaster] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

SET IDENTITY_INSERT [dbo].[tbl_FinanceAccessMaster] ON 

INSERT [dbo].[tbl_FinanceAccessMaster] ([id], [FinanceAccess], [Type]) VALUES (1, N'MAKE PAYMENT', 0)
INSERT [dbo].[tbl_FinanceAccessMaster] ([id], [FinanceAccess], [Type]) VALUES (2, N'MANAGE SPONSORSHIP', 0)
INSERT [dbo].[tbl_FinanceAccessMaster] ([id], [FinanceAccess], [Type]) VALUES (3, N'MANNUAL BILL', 0)
INSERT [dbo].[tbl_FinanceAccessMaster] ([id], [FinanceAccess], [Type]) VALUES (4, N'SET FEEGROUP', 0)
INSERT [dbo].[tbl_FinanceAccessMaster] ([id], [FinanceAccess], [Type]) VALUES (5, N'UPDATE ACCOUNTNO', 0)
INSERT [dbo].[tbl_FinanceAccessMaster] ([id], [FinanceAccess], [Type]) VALUES (6, N'INSTALLMENT', 0)
INSERT [dbo].[tbl_FinanceAccessMaster] ([id], [FinanceAccess], [Type]) VALUES (7, N'CN', 0)
INSERT [dbo].[tbl_FinanceAccessMaster] ([id], [FinanceAccess], [Type]) VALUES (8, N'DN', 0)
INSERT [dbo].[tbl_FinanceAccessMaster] ([id], [FinanceAccess], [Type]) VALUES (9, N'REFUND', 0)
INSERT [dbo].[tbl_FinanceAccessMaster] ([id], [FinanceAccess], [Type]) VALUES (10, N'PAYMENT REQUEST', 1)
INSERT [dbo].[tbl_FinanceAccessMaster] ([id], [FinanceAccess], [Type]) VALUES (11, N'REFUND REQUEST', 2)
INSERT [dbo].[tbl_FinanceAccessMaster] ([id], [FinanceAccess], [Type]) VALUES (12, N'INSTALLMENT REQUEST', 3)
INSERT [dbo].[tbl_FinanceAccessMaster] ([id], [FinanceAccess], [Type]) VALUES (13, N'WITHDRAW REQUEST', 4)
INSERT [dbo].[tbl_FinanceAccessMaster] ([id], [FinanceAccess], [Type]) VALUES (14, N'DEFER REQUEST', 5)
INSERT [dbo].[tbl_FinanceAccessMaster] ([id], [FinanceAccess], [Type]) VALUES (15, N'TERMINATION REQUEST', 6)
INSERT [dbo].[tbl_FinanceAccessMaster] ([id], [FinanceAccess], [Type]) VALUES (16, N'STATEMENT OF ACCOUNT', 0)
INSERT [dbo].[tbl_FinanceAccessMaster] ([id], [FinanceAccess], [Type]) VALUES (17, N'FULL STUDENT LEDGER', 0)
INSERT [dbo].[tbl_FinanceAccessMaster] ([id], [FinanceAccess], [Type]) VALUES (18, N'MAIN STUDENT LEDGER', 0)
INSERT [dbo].[tbl_FinanceAccessMaster] ([id], [FinanceAccess], [Type]) VALUES (19, N'SUB STUDENT LEDGER', 0)
INSERT [dbo].[tbl_FinanceAccessMaster] ([id], [FinanceAccess], [Type]) VALUES (20, N'CLEARANCE REQUEST', 8)
INSERT [dbo].[tbl_FinanceAccessMaster] ([id], [FinanceAccess], [Type]) VALUES (21, N'DOCKET CLEARANCE REQUEST', 9)
INSERT [dbo].[tbl_FinanceAccessMaster] ([id], [FinanceAccess], [Type]) VALUES (22, N'VISA RENEWAL REQUEST', 10)
SET IDENTITY_INSERT [dbo].[tbl_FinanceAccessMaster] OFF
END

