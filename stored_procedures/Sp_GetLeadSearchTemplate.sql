IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetLeadSearchTemplate]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_GetLeadSearchTemplate]
@UserId bigint
as
begin 
select TemplateId,TabName from Tbl_LeadSearchTemplate where DelStatus=0 and CreatedBy=@UserId
end
');
END;