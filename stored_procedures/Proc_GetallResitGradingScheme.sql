-- Check if the stored procedure [dbo].[Proc_GetallResitGradingScheme] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetallResitGradingScheme]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_GetallResitGradingScheme]  
        AS  
        BEGIN  
            SELECT * 
            FROM Tbl_GradingScheme  
            WHERE resit_status = 1  
            ORDER BY Grade_Scheme_id DESC;  
        END
    ')
END
