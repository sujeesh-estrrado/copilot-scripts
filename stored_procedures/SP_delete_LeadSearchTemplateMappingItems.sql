IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_delete_LeadSearchTemplateMappingItems]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_delete_LeadSearchTemplateMappingItems]

@TemplateId bigint

AS
BEGIN

Delete  from NationalityTemplateMapping where TemplateId=@TemplateId
Delete  from SourcetypeTemplateMapping where TemplateId=@TemplateId
Delete  from LeadstatusTemplateMapping where TemplateId=@TemplateId
Delete  from InterestlevelTemplateMapping where TemplateId=@TemplateId
Delete  from CounsellorTemplateMapping where TemplateId=@TemplateId


END
    ')
END
