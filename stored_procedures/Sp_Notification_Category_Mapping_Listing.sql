IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Notification_Category_Mapping_Listing]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Notification_Category_Mapping_Listing]
AS
BEGIN
		select * from Tbl_Notification_mapping NM inner join [dbo].[tbl_Role] R on NM.Role_Id=R.[role_Id]
END
');
END;
