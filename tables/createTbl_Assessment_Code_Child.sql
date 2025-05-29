-- Check if the table exists before creating it
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Assessment_Code_Child]') AND type = N'U')
BEGIN
    CREATE TABLE [dbo].[Tbl_Assessment_Code_Child] (
    [Assessment_Child_Id] BIGINT          IDENTITY (1, 1) NOT NULL,
    [Assessment_Code_Id]  BIGINT          NULL,
    [Assessment_Type_Id]  BIGINT          NULL,
    [Assessment_Perc]     DECIMAL (18, 2) NULL,
    [GivenMarks]          DECIMAL (18, 2) NULL,
    [Passing_Marks]       DECIMAL (18, 2) NULL,
    [Allowance]           DECIMAL (18, 2) NULL,
    [Grading_Scheme]      VARCHAR (50)    NULL,
    [Last]                BIT             NULL,
    [AssesmentTypeCode]   VARCHAR (50)    NULL,
    CONSTRAINT [PK_Tbl_Assessment_Code_Child] PRIMARY KEY CLUSTERED ([Assessment_Child_Id] ASC)
)



END

