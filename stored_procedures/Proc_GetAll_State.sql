-- Check if the stored procedure [dbo].[Proc_GetAll_State] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAll_State]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_GetAll_State]
        AS
        BEGIN
            SELECT * 
            FROM Tbl_State
        END
    ')
END
