IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SelectallCompulsoryFees]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_SelectallCompulsoryFees]
        AS
        BEGIN
            SELECT 
                c.*, 
                d.Department_Name,
                c.TypeOfStudent AS typestu
            FROM dbo.Tbl_Fee_Compulsory c
            INNER JOIN Tbl_Department d ON d.Department_Id = c.CourseId
            ORDER BY c.CompulsoryFeeId DESC
        END
    ')
END
