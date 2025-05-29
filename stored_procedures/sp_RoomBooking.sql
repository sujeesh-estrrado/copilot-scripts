IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_RoomBooking]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_RoomBooking]   -- 13,0,4         
(                  
@Flag bigint =0,                  
@ID bigint =0,                  
@Room bigint =0,                  
@StartDateTime datetime ='''',                  
--@StartTime time(7)='''',                  
@EndDateTime datetime  ='''',                  
--@EndTime time(7)='''',              
@Description varchar(MAX) ='''',                  
@SeatNos int =0,                  
@RequestedBy bigint =0,                  
@RequestedDate datetime ='''',                  
@ApprovalBy bigint =0,                  
@ApprovalDate datetime ='''',                  
@ApprovalRemark varchar(MAX) ='''',                  
@ApprovalStatus int =0,                  
@BookingID bigint = 0,                  
@RoomBookingDate  datetime ='''',                  
@Session int =0,                  
@Room_Typ bigint = 0,                  
@Campus_Id bigint = 0,                  
@Block_Id bigint = 0,                  
@Floor_Id bigint = 0,                  
@ExamBooking bigint = 0,        
@RefType varchar(MAX) ='''',        
@RefID bigint = 0,        
@Status int =0                  
)                  
as    
 Declare @referenceID bigint  
begin                  
 if @Flag = 1  --Insert into RoomBooking Request                  
 begin                  
 INSERT INTO [dbo].[tbl_RoomBooking]([Room],StartDateTime,EndDateTime,[Description],[SeatNos]                  
           ,[RequestedBy],[RequestedDate],[ApprovalStatus],RefType,RefID)                  
     VALUES                  
           (@Room,@StartDateTime,@EndDateTime,@Description,@SeatNos,                  
     @RequestedBy,GETDATE(),0,@RefType,@RefID)                  
              
  SELECT SCOPE_IDENTITY() AS RoomBookingID               
 end                  
                  
                  
 if @Flag = 2  --Insert into RoomBookingSession Log                  
 begin                  
  INSERT INTO [dbo].[tbl_RoomBookingSessionLog]                  
           ([BookingID]                  
           ,[Room]                  
           ,RoomBookingDate            
     ,Seats            
           ,[Session]                  
           ,[Status])                  
  VALUES                  
           (@BookingID, @Room,@RoomBookingDate,@SeatNos,@Session,@Status)                  
 end                  
                  
 if @Flag = 3  --Approve RoomBooking Request    
 begin                  
  UPDATE [dbo].[tbl_RoomBooking]                  
  SET [ApprovalBy] = @ApprovalBy                  
   ,[ApprovalDate] = GETDATE()                  
   ,[ApprovalRemark] = @ApprovalRemark                  
   ,[ApprovalStatus] = 1                  
  WHERE ID = @ID                  
                  
  update [tbl_RoomBookingSessionLog] set [Status] = 1                  
  where [BookingID] = @ID  
    
  set @referenceID=(select RefID from [dbo].[tbl_RoomBooking] where  [ID]= @ID)  
  --update primary interview venue  
  update [dbo].[Tbl_HRMS_Primary_Interview_Details] set [Interview_Status]=''Approved'' where [Application_No]=@referenceID  
 end                  
                   
 if @Flag = 4  --Reject RoomBooking Request                  
 begin                  
  UPDATE [dbo].[tbl_RoomBooking]                  
  SET [ApprovalBy] = @ApprovalBy                  
   ,[ApprovalDate] = GETDATE()                  
   ,[ApprovalRemark] = @ApprovalRemark                  
   ,[ApprovalStatus] = 2                  
  WHERE ID = @ID     
  update [tbl_RoomBookingSessionLog] set [Status] = 2                  
  where [BookingID] = @ID                  
 set @referenceID=(select RefID from [dbo].[tbl_RoomBooking] where  [ID]= @ID)  
  --update primary interview venue  
  update [dbo].[Tbl_HRMS_Primary_Interview_Details] set [Interview_Status]=''Rejected'' where [Application_No]=@referenceID  
 end                  
                  
 if @Flag = 4  --Get all RoomBooking Request                  
 begin                  
  SELECT [ID],[Room],StartDateTime,StartDateTime,[Description],[SeatNos],[RequestedBy]                  
   ,[RequestedDate],[ApprovalBy],[ApprovalDate],[ApprovalRemark],[ApprovalStatus]                  
  FROM [dbo].[tbl_RoomBooking]                  
  where [ApprovalStatus] = 0                  
 end                  
 if @Flag = 5  --Get all room bookings by roomid and date                  
 begin                  
  select * from tbl_RoomBookingSessionLog                  
  where ([Status] = 0 or [Status] = 1)                  
  and RoomBookingDate = @RoomBookingDate                  
  and Room = @Room                  
                  
 end                  
 if @Flag = 6  --Get all room bookings by date                
 begin                  
  select *           
  from tbl_RoomBookingSessionLog           
  where ([Status] = 0 or [Status] = 1)                  
  and RoomBookingDate = @RoomBookingDate                  
  and Room = @Room                
  and [Session] = @Session                
  --in (select Room_Id from Tbl_Room where                  
  --        (Room_Type = @Room_Typ or @Room_Typ =0) and                  
  --        (Campus_Id = @Campus_Id or @Campus_Id =0)and                  
  --        (Block_Id = @Block_Id or @Block_Id =0)and                  
  --        (Floor_Id = @Floor_Id or @Floor_Id =0)                  
  --        )                  
                
 end                 
 if @Flag = 7  --Get rooms with filter                
 begin                  
  SELECT Room_Id,Room_Name,Campus_Id,Block_Id,Floor_Id,                
    Seat_Capacity,Exam_SeatCapacity,Room_Status                
  FROM [Tbl_Room]                 
  where Room_Status = 0 and                
    (Room_Type = @Room_Typ or @Room_Typ =0) and                 
    (Campus_Id = @Campus_Id or @Campus_Id =0)and                  
    (Block_Id = @Block_Id or @Block_Id =0)and                  
    (Floor_Id = @Floor_Id or @Floor_Id =0)                  
 end                 
 if @Flag = 8  --Get roomsDeatails by RoomID                
 begin                  
  SELECT R.[Room_Id]                      
  ,R.[Room_Name]                      
  ,R.[Campus_Id]                      
  ,R.[Block_Id]                      
  ,R.[Floor_Id]                      
  ,R.[Seat_Capacity]                      
  ,R.[Exam_SeatCapacity]                      
  ,R.[Room_Status]                    
  ,C.Organization_Name  as Campus_Name                  
  ,B.Block_Name                    
  ,F.Floor_Name,                
  RT.Room_type                
  FROM [Tbl_Room]  R                    
  INNER JOIN [Tbl_Organzations ] C On R.Campus_Id=C.Organization_Id                    
  INNER JOIN Tbl_Block B On R.Block_Id=B.Block_Id                    
  INNER JOIN Tbl_Floor F On R.Floor_Id=F.Floor_Id                 
  left join Tbl_Room_Type RT on Rt.Room_type_id = R.Room_Type                
  where R.Room_Id = @Room                
 end                
 if @Flag = 9  --Get room availability by roomid , date and Time              
 begin               
  select * from [tbl_RoomBooking]              
  where (ApprovalStatus = 0 or ApprovalStatus=1)              
  and Room = @Room              
   and  (          
  ( (@StartDateTime between StartDateTime and EndDateTime) and @StartDateTime !=EndDateTime)  or        
  ( (@EndDateTime between StartDateTime and EndDateTime) and @EndDateTime != StartDateTime )  or        
  (StartDateTime>=@StartDateTime and EndDateTime<=@EndDateTime)              
   )            
 end              
            
 if @Flag = 10  --Get Exam Room availibility by             
 begin               
            
  select  R.Room_Id,R.Room_Name, R.Seat_Capacity,R.Exam_SeatCapacity,COALESCE(SUM(RB.SeatNos),0) as AllocatedStudents,         
 (R.Exam_SeatCapacity-COALESCE(SUM(RB.SeatNos),0)) as AvailSeats        
 from Tbl_Room R        
 left join tbl_RoomBooking RB on RB.Room = R.Room_Id         
 and  (          
  ( @StartDateTime between StartDateTime and EndDateTime)  or        
  ( (@EndDateTime between StartDateTime and EndDateTime) and @EndDateTime != StartDateTime )  or        
  (StartDateTime>=@StartDateTime and EndDateTime<=@EndDateTime)              
   )          
        
 where Room_Status =0 and Room_Type=1       
          
 group by R.Room_Id, R.Seat_Capacity,R.Exam_SeatCapacity  ,R.Room_Name      
 having      
 (R.Exam_SeatCapacity-COALESCE(SUM(RB.SeatNos),0))>0      
        
 end            
 if @Flag = 11  --Get RoomBooking Details By BookingID            
 begin               
  select RM.*,            
   case             
    when RM.ApprovalStatus = 0 then ''Approval Pending''            
    when RM.ApprovalStatus = 1 then ''Approved''            
    when RM.ApprovalStatus = 2 then ''Rejected''            
   end            
   as FacilityApprovalStatus,            
   R.Room_Name,RT.Room_type,Concat(RE.Employee_FName,'' '',RE.Employee_LName) as RequestedBy,      
   Concat(AE.Employee_FName,'' '',AE.Employee_LName) as ApprovedBy            
  from tbl_RoomBooking RM             
   join Tbl_Room R on R.Room_Id = RM.Room            
   join Tbl_Room_Type RT on RT.Room_type_id = R.Room_Type            
   left join Tbl_Employee RE on RE.Employee_Id = RM.RequestedBy            
   left join Tbl_Employee AE on AE.Employee_Id = RM.ApprovalBy            
  where RM.ID = @BookingID            
 end            
 if @Flag = 12  --Get RoomBooking Details By Time, Session and Room            
 begin               
  select RM.*,            
   case             
   when RM.ApprovalStatus = 0 then ''Approval Pending''            
   when RM.ApprovalStatus = 1 then ''Approved''            
   when RM.ApprovalStatus = 2 then ''Rejected''            
   end            
   as FacilityApprovalStatus,            
   R.Room_Name,RT.Room_type,Concat(RE.Employee_FName,'' '',RE.Employee_LName) as RequestedBy,            
   Concat(AE.Employee_FName,'' '',AE.Employee_LName) as ApprovedBy            
  from tbl_RoomBooking RM             
   join Tbl_Room R on R.Room_Id = RM.Room            
   left join Tbl_Room_Type RT on RT.Room_type_id = R.Room_Type            
   left join Tbl_Employee RE on RE.Employee_Id = RM.RequestedBy            
   left join Tbl_Employee AE on AE.Employee_Id = RM.ApprovalBy            
  where RM.ID in ( select BookingID           
   from tbl_RoomBookingSessionLog           
   where ([Status] = 0 or [Status] = 1)                  
   and RoomBookingDate = @RoomBookingDate                  
   and Room = @Room                
   and [Session] = @Session )            
 end        
 if(@Flag=13)      
 begin      
      
  select  R.Room_Id,R.Room_Name, R.Seat_Capacity,R.Exam_SeatCapacity,COALESCE(SUM(RB.SeatNos),0) as AllocatedStudents,         
 (R.Exam_SeatCapacity-COALESCE(SUM(RB.SeatNos),0)) as AvailSeats        
 from Tbl_Room R        
 left join tbl_RoomBooking RB on RB.Room = R.Room_Id         
 and  (          
  ( @StartDateTime between StartDateTime and EndDateTime)  or        
  ( (@EndDateTime between StartDateTime and EndDateTime) and @EndDateTime != StartDateTime )  or        
  (StartDateTime>=@StartDateTime and EndDateTime<=@EndDateTime)              
   )          
        
 where Room_Status =0 and Room_Type=1  and Room_Id=@Room      
          
 group by R.Room_Id, R.Seat_Capacity,R.Exam_SeatCapacity  ,R.Room_Name      
      
 end      
    
 if @Flag = 14  --Get RoomBooking Details By BookingID            
 begin               
 select RM.*,            
  case             
  when RM.ApprovalStatus = 0 then ''Approval Pending''            
  when RM.ApprovalStatus = 1 then ''Approved''            
  when RM.ApprovalStatus = 2 then ''Rejected''            
  end            
  as FacilityApprovalStatus,            
  R.Room_Name,RT.Room_type,Concat(RE.Employee_FName,'' '',RE.Employee_LName) as RequestedEmp,            
  Concat(AE.Employee_FName,'' '',AE.Employee_LName) as ApprovedBy            
 from tbl_RoomBooking RM             
  join Tbl_Room R on R.Room_Id = RM.Room            
  join Tbl_Room_Type RT on RT.Room_type_id = R.Room_Type            
  left join Tbl_Employee RE on RE.Employee_Id = RM.RequestedBy            
  left join Tbl_Employee AE on AE.Employee_Id = RM.ApprovalBy            
 where RM.ApprovalStatus=0    
 end       
  if @Flag = 15    
 begin               
 select  R.Room_Id,R.Room_Name, R.Seat_Capacity,R.Exam_SeatCapacity,COALESCE(SUM(RB.SeatNos),0) as AllocatedStudents,         
 (R.Exam_SeatCapacity-COALESCE(SUM(RB.SeatNos),0)) as AvailSeats        
 from Tbl_Room R        
 left join tbl_RoomBooking RB on RB.Room = R.Room_Id         
 and  (          
  ( @StartDateTime between StartDateTime and EndDateTime)  or        
  ( (@EndDateTime between StartDateTime and EndDateTime) and @EndDateTime != StartDateTime )  or        
  (StartDateTime>=@StartDateTime and EndDateTime<=@EndDateTime)              
   )          
 where Room_Status =0 and Room_Type!=1       
          
 group by R.Room_Id, R.Seat_Capacity,R.Exam_SeatCapacity  ,R.Room_Name      
 having      
 (R.Exam_SeatCapacity-COALESCE(SUM(RB.SeatNos),0))>0    
  
 end    
end ');
END;