-- Check if the stored procedure [dbo].[Proc_GetallGradingScheme] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetallGradingScheme]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_GetallGradingScheme]  
        AS  
        BEGIN  
            SELECT *, 
                   CASE WHEN resit_status = 1 THEN ''Yes'' ELSE ''No'' END AS resit 
            FROM Tbl_GradingScheme   
            ORDER BY Grade_Scheme_id DESC  
        END
    ')
END
