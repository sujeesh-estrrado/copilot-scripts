IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Read_all_Notification]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Read_all_Notification] --30135
(@userid bigint)
as
begin 
update Tbl_NotificationNew set IsRead_Status=1 where User_Id=@userid;
update Tbl_User_notification_mapping set ReadUnreadStatus=1 where UserId=@userid;
end');
END;