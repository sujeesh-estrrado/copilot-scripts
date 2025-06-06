IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Event_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[SP_Update_Event_Details]    
(    
        
     @Event_name  varchar (max),    
  @Agent   varchar (max),    
  @TypeOfEvent   varchar (max) ,    
  @EventPlanned   varchar (max),    
  @EventLocation   varchar (max),    
  @EventStartDate   datetime ,    
  @EventEndDate   datetime,    
     @EventTime   varchar (max) ,    
  @Country bigint,    
  @State   bigint  ,    
  @City   bigint  ,    
  @EventVennu   varchar (max) ,    
  @BoothNo   varchar(max)  ,    
  @Boothcount   bigint ,    
  @TargetStudent   bigint ,    
  @Event_Id bigint,    
  @ExpiredDate datetime,    
  @TeamId bigint    
      
     
)    
As    
    
Begin    
    
    
    
 update Tbl_Event_Details set EventName=@Event_name,Agent=@Agent,Inside_Outside=@EventPlanned,TypeofEvent=@TypeOfEvent,    
       International_or_Local=@EventLocation,Start_Date=@EventStartDate,End_Date=@EventEndDate,Time=@EventTime,    
    Country=@Country,State=@State,City=@City,EventVennu=@EventVennu,BoothNo=@BoothNo,BoothCount=@Boothcount,TargetedStudent=@TargetStudent ,ExpiredDate=@ExpiredDate,Team_Id=@TeamId    
    where Event_Id=@Event_Id and Del_status=0    
    
      
    
End   
    ')
END
