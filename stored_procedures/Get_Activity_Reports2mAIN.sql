IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_Activity_Reports2mAIN]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Get_Activity_Reports2mAIN]  
        AS  
        BEGIN  
            
            SELECT * FROM dbo.OverallActivityReport2;  
        END
    ')
END;
