IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[get_all_categorys]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[get_all_categorys]
        AS
        BEGIN
            
            
            SELECT * FROM Tbl_Course_Category;
        END
    ')
END
