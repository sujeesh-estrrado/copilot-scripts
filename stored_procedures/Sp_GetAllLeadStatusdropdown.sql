IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetAllLeadStatusdropdown]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_GetAllLeadStatusdropdown]
as
begin

Select  Lead_Status_Id,Lead_Status_Name from Tbl_Lead_Status_Master where Lead_Status_DelStatus=0
end
'
)
END;
