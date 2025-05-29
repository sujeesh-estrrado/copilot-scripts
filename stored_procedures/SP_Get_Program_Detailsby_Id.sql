IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Program_Detailsby_Id]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[SP_Get_Program_Detailsby_Id]
    (
        @Department_Id1 BIGINT = 0,
        @Department_Id2 BIGINT = 0,
        @Department_Id3 BIGINT = 0
    )
    AS
    BEGIN
        SELECT Department_Id, AnnualPracticingCertification 
        FROM dbo.Tbl_Department
        WHERE 
            (Department_Id = @Department_Id1 
             OR Department_Id = @Department_Id2 
             OR Department_Id = @Department_Id3)
            AND AnnualPracticingCertification = ''Yes''
    END
    ')
END
GO
