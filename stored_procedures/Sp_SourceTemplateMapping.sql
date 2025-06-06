IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_SourceTemplateMapping]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_SourceTemplateMapping]
        @templateid BIGINT,
        @sourceId VARCHAR(100)
        AS
        BEGIN
            INSERT INTO SourcetypeTemplateMapping(Sourcetype, TemplateId, DelStatus) 
            VALUES (@sourceId, @templateid, 0);
        END
    ')
END
