IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_NotificationPrivilage]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_NotificationPrivilage] --3,60950                  
(            
@flag bigint=0,            
@roleid bigint=0,            
@Page_Id bigint=0,          
@Button_Id bigint=0,          
@Privilage_Status bit=Null,          
@TypeID bigint=0          
)                 
AS                  
                  
BEGIN            
if(@flag=0)            
 begin            
  select Notification_TypeId,Notification_Type     
  from Tbl_NotificationType     
  order by Notification_Type    
 end            
           
if(@flag=1)            
begin            
             
    select NP.* from Tbl_Role R            
 inner join Tbl_Notification_Privilage NP on R.role_Id=NP.Role_Id          
 inner join Tbl_NotificationType NT on NT.Notification_TypeId=NP.NotificationType_Id          
 where NP.Role_id=@roleid and Notification_TypeId=@TypeID          
        
end     
if(@flag=2)            
begin            
             
   delete  from Tbl_Notification_Privilage   
   where  NotificationType_Id=@TypeID    
        
end  
if(@flag=3)            
begin            
             
 --select * from Tbl_Notification_Privilage   
 Insert into Tbl_Notification_Privilage (NotificationType_Id,Role_Id,Privilage_Status,Created_Date,Delete_Status)        
 values(@TypeID,@roleid,@Privilage_Status,GETDATE(),0)       
        
end  
if(@flag=4)            
begin            
             
  --select * from Tbl_Notification_Privilage   
 select NotificationType_Id,NP.Role_Id ,R.role_Name  
 from Tbl_Notification_Privilage NP  
 inner join tbl_Role R on R.role_Id=NP.Role_Id  
   
 where Privilage_Status=1 and NotificationType_Id=@TypeID  
        
end  
End
');
END;
