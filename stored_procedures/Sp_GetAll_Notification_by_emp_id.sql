IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetAll_Notification_by_emp_id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_GetAll_Notification_by_emp_id] --10
(@userid bigint)
as
begin
--SELECT       dbo.Tbl_NotificationNew.Notification_msg, dbo.Tbl_NotificationNew.Notification_date, dbo.Tbl_NotificationNew.Notification_id, dbo.Tbl_NotificationNew.Notification_url, dbo.Tbl_NotificationNew.IsRead_Status, 
--                         dbo.Tbl_NotificationNew.Category, dbo.Tbl_NotificationNew.Sented_by, dbo.Tbl_NotificationNew.User_Id, dbo.Tbl_NotificationNew.Category_id, dbo.Tbl_User_notification_mapping.ReadUnreadStatus, 
--                         dbo.Tbl_User_notification_mapping.RoleId
--FROM            dbo.Tbl_User_notification_mapping INNER JOIN
--                         dbo.Tbl_NotificationNew ON dbo.Tbl_User_notification_mapping.NotificationId = dbo.Tbl_NotificationNew.Notification_id where UserId=@userid   and Message_Sent_Status=1 order by  Tbl_NotificationNew.Notification_id desc
SELECT DISTINCT
    N.Notification_id, 
    N.Notification_date, 
    N.Notification_msg, 
    N.Notification_url
FROM dbo.Tbl_NotificationNew AS N
WHERE N.Emp_Id = @userid 
ORDER BY N.Notification_id DESC;

end
    ')
END
