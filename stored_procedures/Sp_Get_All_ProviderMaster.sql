IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_ProviderMaster]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[Sp_Get_All_ProviderMaster]
AS
Begin

Select ProviderId, ProviderCode,ProviderName,ProviderSecondName,ProviderAddress,ProviderTelephone,
ProviderFax,ProviderEmail from Tbl_ProviderMaster where Status=1

End 
    ')
END
