-- Check if the stored procedure [dbo].[Proc_Insert_New_Admission_Category] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert_New_Admission_Category]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Insert_New_Admission_Category]
        (
            @Course_Level_Id BIGINT,
            @Course_Category_Id BIGINT,
            @FromDate DATETIME,
            @ToDate DATETIME,
            @EndDate DATETIME
        )
        AS
        BEGIN
            -- Insert new admission category record into tbl_New_Admission_Category table
            INSERT INTO tbl_New_Admission_Category
            (
                Course_Level_Id,
                Course_Category_Id,
                FromDate,
                ToDate,
                EndDate,
                Admission_Status
            )
            VALUES
            (
                @Course_Level_Id,
                @Course_Category_Id,
                @FromDate,
                @ToDate,
                @EndDate,
                1
            );
        END
    ')
END
