IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Event_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Insert_Event_Details]    
(    
     @Event_name  varchar (max),    
  @Agent   varchar (max),    
  @EventLeader   bigint,    
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
  @ExpiredDate  datetime,    
  @TeamId  bigint    
)    
As    
    
Begin    
    
 Insert into Tbl_Event_Details    
     (EventName,    
     Agent,    
     EventLeader,    
     Inside_Outside,    
     TypeofEvent,    
     International_or_Local,    
     Start_Date,    
     End_Date,    
     Time,    
     Country,    
     State,    
     City,    
     EventVennu,    
     BoothNo,    
     BoothCount,    
     TargetedStudent,    
     MarketingMangerApproval_ID,    
     PsoApproval_ID,    
     DirectorApproval_ID,    
     CreatedDate,    
     Del_status,OtherStaff,ExpiredDate,Team_Id    
     )    
 values(@Event_name,    
        @Agent,    
     @EventLeader,    
     @EventPlanned,    
     @TypeOfEvent,    
     @EventLocation,    
     @EventStartDate,    
     @EventEndDate,    
     @EventTime,    
     @Country,    
     @State,    
     @City,    
     @EventVennu,    
     @BoothNo,    
     @Boothcount,    
        @TargetStudent,    
     0,    
     0,    
     0,    
     getdate(),    
     0,0,@ExpiredDate,@TeamId)    
     
 Select SCOPE_IDENTITY()    
End ');
END;
