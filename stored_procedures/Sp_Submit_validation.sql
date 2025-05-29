IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Submit_validation]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Submit_validation]
@leadstatusname varchar(50) = ''''

as
begin
      select count (*) AS LeadStatusCount from Tbl_Lead_Status_Master where Lead_Status_Name = @leadstatusname and Lead_Status_DelStatus = 0
 end
'
)
END;
