IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Insert_Notice_NotificationByEmp]') 
    AND type = N'P'
)
BEGIN
    EXEC('
create procedure [dbo].[Sp_Insert_Notice_NotificationByEmp]
(@userid bigint,@createdate datetime,@notificationmsg varchar(max),@noticeurl varchar(max))
as
begin
  INSERT INTO Tbl_NotificationNew (Emp_Id, Notification_date, Notification_msg,Notification_url,IsRead_Status)
    VALUES (@userid, @createdate, @notificationmsg,@noticeurl,0);
	end
   ');
END;
