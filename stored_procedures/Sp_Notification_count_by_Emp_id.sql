IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Notification_count_by_Emp_id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Notification_count_by_Emp_id] --30077
 (@userid bigint)
as
begin

 SELECT COUNT(Notification_id) AS notificationCount  
    FROM dbo.Tbl_NotificationNew  
    WHERE Emp_Id = @userid  
    AND IsRead_Status = 0;  


--SELECT       count( N.Notification_id) As notificationCount
--FROM            dbo.Tbl_User_notification_mapping AS NM INNER JOIN
--                         dbo.Tbl_NotificationNew AS N ON NM.NotificationId = N.Notification_id where Emp_Id=@userid and Message_Sent_Status=1 and IsRead_Status=0
					
--SELECT       count( dbo.Tbl_User_notification_mapping.UserId) As notificationCount
--FROM            dbo.Tbl_NotificationNew INNER JOIN
--                         dbo.Tbl_User_notification_mapping ON dbo.Tbl_NotificationNew.User_Id = dbo.Tbl_User_notification_mapping.UserId where UserId=@userid and Message_Sent_Status=1;
						 end
');
END;
