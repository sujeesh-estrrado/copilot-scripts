IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetOrganizationId_ByCode]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_GetOrganizationId_ByCode]
(
@OrganizationCode varchar(10)
) 
as begin  
select Organization_id from  dbo.Tbl_Organzation where  
Organization_Code=@OrganizationCode and
Organization_DelStatus=0
end
    ')
END
