IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_get_prgm_code]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE PROCEDURE [dbo].[sp_get_prgm_code]
AS
BEGIN
    SELECT Course_Category_Id, Program_Code
    FROM Tbl_Course_Category
    WHERE Course_Category_Status = 0
    AND  Program_Code !=''''--Program_Code IS NOT NULL;
END;

    ')
END
