IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_QuestionsByFormId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Get_QuestionsByFormId]
(
    @Permanent_FormId BIGINT
)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        QM.Mapping_Id,
        QM.Permanent_FormId,
        QM.question_type AS QuestionType,
        QM.question AS QuestionText,
        QM.options AS Options,
        QM.upload_Type AS SelectedDocLimit
    FROM 
        tbl_PermanentFormMapping QM
    WHERE 
        QM.Permanent_FormId = @Permanent_FormId
  
END
   ')
END;
