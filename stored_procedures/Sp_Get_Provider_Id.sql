IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Provider_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[Sp_Get_Provider_Id]
(@ProviderId bigint)
As
Begin

Select ProviderCode,ProviderName,ProviderSecondName,ProviderAddress,ProviderTelephone,ProviderFax,ProviderEmail
from dbo.Tbl_ProviderMaster where ProviderId=@ProviderId and Status=1

End  
    ')
END
