IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAll_ID_By_Level_Category_Department]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_GetAll_ID_By_Level_Category_Department]
        AS
        BEGIN
            SELECT * 
            FROM dbo.tbl_New_Admission  
            WHERE Admission_Status = 1
        END
    ')
END
