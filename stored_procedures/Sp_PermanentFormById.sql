IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_PermanentFormById]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_PermanentFormById]
    @Permanent_FormId BIGINT,
    @Status INT = NULL
AS
BEGIN
    SELECT 
        pf.Permanent_FormId,
        pf.Form_Title,
        pf.Form_Type,
        pf.Status,
        pm.Mapping_Id,
        pm.Question_Type,
        pm.Question,
        pm.Options,
        pm.Upload_Type
    FROM 
        Tbl_PermanentForm pf
    INNER JOIN 
        tbl_PermanentFormMapping pm
    ON 
        pf.Permanent_FormId = pm.Permanent_FormId
    WHERE 
        pf.Permanent_FormId = @Permanent_FormId
        AND (@Status IS NULL OR pf.Status = @Status)
        AND (pm.Delete_Status IS NULL OR pm.Delete_Status = 0)
END
   ')
END;
