IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_DeleteLeadSearchTemplate]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_DeleteLeadSearchTemplate]
@templateid bigint
as
begin 
update Tbl_LeadSearchTemplate set DelStatus=1 where TemplateId=@templateid
end
    ')
END
