IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Delete_All_Caption_From_Org]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Delete_All_Caption_From_Org]
        AS
        BEGIN
            
            
            DELETE FROM Tbl_Title;
        END
    ')
END
