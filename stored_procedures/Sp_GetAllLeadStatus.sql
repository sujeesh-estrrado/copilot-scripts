IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetAllLeadStatus]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_GetAllLeadStatus]
@flag tinyint
as
begin
if(@flag=1)
begin
select Lead_Status_Id as LeadId,
Lead_Status_Name as LeadName from Tbl_Lead_Status_Master where Lead_Status_DelStatus=0
end
end


');
END;
