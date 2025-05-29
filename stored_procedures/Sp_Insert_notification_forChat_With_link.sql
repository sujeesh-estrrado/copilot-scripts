IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Insert_notification_forChat_With_link]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Insert_notification_forChat_With_link](@Notification_Msg varchar(MAX),  
  
   
 @User_Id bigint,  
 @Senter bigint,

 @categoryname varchar(200),
 @Url varchar(500))
 as
  declare @notfound bigint
 begin
 if not exists (select  * from Tbl_NotificationNew where Notification_msg=@Notification_Msg and User_Id=@User_Id and Category=@categoryname)
 begin
 insert into Tbl_NotificationNew(Notification_msg,Notification_date,Sented_by,User_Id,IsRead_Status,Notification_url,Category)
 values(@Notification_Msg,GETDATE(),@Senter,@User_Id,0,@url,@categoryname);
 set @notfound=(select MAX(Notification_id) from Tbl_NotificationNew)
 insert into Tbl_User_notification_mapping(NotificationId,CreatedDate,UserId,Message_Sent_Status,RoleId,ReadUnreadStatus) values(@notfound,getdate(),@User_Id,1,0,0);
 end
 else
 begin

 update Tbl_NotificationNew set Notification_date=GETDATE(),Sented_by=@Senter,Notification_url=@Url,IsRead_Status=0 where User_Id=@User_Id and Notification_msg=@Notification_Msg ;
 set @notfound=(select Notification_id from Tbl_NotificationNew where Notification_msg=@Notification_Msg and User_Id=@User_Id and Category=@categoryname )
 update Tbl_User_notification_mapping set Message_Sent_Status=1,ReadUnreadStatus=0,UpdatedDate=GETDATE() where NotificationId=@notfound;
 end
 end
   ');
END;
