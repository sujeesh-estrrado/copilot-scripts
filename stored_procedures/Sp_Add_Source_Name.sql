IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Add_Source_Name]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Add_Source_Name] 
        @source_name VARCHAR(MAX)
        AS
        BEGIN
            INSERT INTO Tbl_Source_name (Sourse_Name, delete_status)
            VALUES (@source_name, 0);
        END
    ');
END
