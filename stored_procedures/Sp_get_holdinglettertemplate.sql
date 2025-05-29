IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_get_holdinglettertemplate]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[Sp_get_holdinglettertemplate]
    AS
    BEGIN
        SELECT
            TG.Template_id,
            TG.Template_name,
            TG.Html_Url
        FROM
            Tbl_Template_generation TG
        INNER JOIN
            Tbl_Template_Mapping TM ON TM.Template_id = TG.Template_id
        WHERE
            TM.Category = ''Holding Letter'' AND TG.delete_status = 0 AND TM.delete_status = 0
    END
    ')
END
