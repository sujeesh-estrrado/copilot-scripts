-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Assessment_Type]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Assessment_Type] (
    [Assessment_Type_Id]   BIGINT        IDENTITY (1, 1) NOT NULL,
    [Assesment_Type]       VARCHAR (100) NULL,
    [Assessment_Type_Code] VARCHAR (50)  NULL,
    CONSTRAINT [PK_Tbl_Assessment_Type] PRIMARY KEY CLUSTERED ([Assessment_Type_Id] ASC)
);



END

