IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Insert_Notice_Notification]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_Insert_Notice_Notification]
(
    @userid BIGINT,
    @createdate DATETIME,
    @notificationmsg VARCHAR(MAX),
    @noticeurl VARCHAR(MAX)
)
AS
BEGIN
    INSERT INTO Tbl_NotificationNew 
        (User_Id, Notification_date, Notification_msg, Notification_url, IsRead_Status)
    VALUES 
        (@userid, @createdate, @notificationmsg, @noticeurl, 0);
END;

    ');
END;
