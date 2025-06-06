IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_BIND_GRID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_BIND_GRID]
        (@type_of_student VARCHAR(100))
        AS
        BEGIN
            SELECT * 
            FROM tbl_certificate_master 
            WHERE Type_of_student = @type_of_student 
            AND Delete_Status = 0 
            ORDER BY Document_Name ASC;
        END
    ')
END
