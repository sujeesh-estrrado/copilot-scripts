IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAll_Country]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_GetAll_Country]
        AS
        BEGIN
            SELECT * 
            FROM Tbl_Country   
            ORDER BY Country
        END
    ')
END
