IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_Course_Code_unmapped]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[Sp_Get_All_Course_Code_unmapped] --1
    @Org_Id BIGINT  
AS
BEGIN
    SELECT  
        D.Department_Id,
        D.Course_Code,
        D.Department_Name 
    FROM 
        Tbl_Department D  
    WHERE 
        D.Department_Status = 0 
        AND D.Active_Status = ''Active'' 
        AND D.Delete_Status = 0 
        AND D.Org_Id = @Org_Id 
        AND D.Department_Id NOT IN (
            SELECT Program_Category_Id 
            FROM Tbl_Program_Duration
        )
END
    ')
END
