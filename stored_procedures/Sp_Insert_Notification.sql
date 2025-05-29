IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Insert_Notification]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Insert_Notification]( @Notification_Msg varchar(MAX),  
  
   
 @User_Id bigint,  
 @Senter bigint,
 @roleid bigint ,
 @Category varchar(Max)='''')

 as
 declare @notfound bigint
 begin
 insert into Tbl_NotificationNew(Notification_msg,Notification_date,Sented_by,User_Id,IsRead_Status,Notification_url,Category)
 values(@Notification_Msg,GETDATE(),@Senter,@User_Id,0,''#'',@Category);
 set @notfound=(select MAX(Notification_id) from Tbl_NotificationNew)
 insert into Tbl_User_notification_mapping(NotificationId,CreatedDate,UserId,Message_Sent_Status,RoleId,ReadUnreadStatus) values(@notfound,getdate(),@User_Id,1,@roleid,0);

 end

   ');
END;
