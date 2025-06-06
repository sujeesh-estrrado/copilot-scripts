IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAll_newemployee]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_GetAll_newemployee]
        AS
        BEGIN
            SELECT 
                (Employee_FName + '' '' + Employee_LName) AS Employee_Name,
                Employee_Id 
            FROM dbo.Tbl_Employee 
            WHERE Employee_Status = 0
        END
    ')
END
