IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Insert_Notification_With_link]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Insert_Notification_With_link]( @Notification_Msg varchar(MAX),  
  
   
 @User_Id bigint,  
 @Senter bigint,
 @roleid bigint,
 @Url varchar(500),
 @Category varchar(Max)='''',
 @CatId int=0,
 @Flag int=0)

 as
 declare @notfound bigint
 if(@Flag=0)
 begin
	 insert into Tbl_NotificationNew(Notification_msg,Notification_date,Sented_by,User_Id,IsRead_Status,Notification_url,Category,Category_id)
	 values(@Notification_Msg,GETDATE(),@Senter,@User_Id,0,@url,@Category,@CatId);
	 
	 set @notfound=(select MAX(Notification_id) from Tbl_NotificationNew)
	 insert into Tbl_User_notification_mapping(NotificationId,CreatedDate,UserId,Message_Sent_Status,RoleId,ReadUnreadStatus) values(@notfound,getdate(),@User_Id,1,@roleid,0);

 end
 else if(@Flag=1)
 begin
	update Tbl_NotificationNew
	set Notification_url=''#''
	where User_Id=@User_Id and Category_id=10
end
   ');
END;
