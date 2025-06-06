IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_ExamseatLayout]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[sp_ExamseatLayout] --3,60950                        
(                  
@flag bigint=0,                  
@Seat_Arrange_Id bigint=0,         
@Exam_Id bigint=0,         
@Venue bigint=0,         
@SeatNo bigint=0,         
@StudentId  bigint=0,      
@FromTime datetime=null,      
@ToTime datetime=null,      
@Created_By bigint=0      
)                       
AS                        
                        
BEGIN                  
if(@flag=0)                  
 begin                  
  select Seat_Arrange_Id,Exam_Id,Venue,SeatNo,StudentId        
  from Tbl_ExamseatLayout        
 end                  
                 
        
if(@flag=1)                  
begin     
if not exists(select * from Tbl_ExamseatLayout where Exam_Id=@Exam_Id and studentId=@StudentId )  
begin  
    if not exists (select * from Tbl_ExamseatLayout where Exam_Id=@Exam_Id  and    
  (                
    ( @FromTime  between FromTime and ToTime)  or              
    (      
     (      
    @ToTime between FromTime and ToTime      
      )       
      and       
     @ToTime  != FromTime )        
      or              
      (      
       FromTime>=@FromTime ) and ToTime<=@ToTime ) and StudentId=@StudentId)    
    begin    
 Insert into Tbl_ExamseatLayout (Exam_Id,Venue,SeatNo,StudentId,FromTime,ToTime,Created_By,Created_Date,Delete_Status)              
 values(@Exam_Id,@Venue,(select case when  max(SeatNo)+1 is null then 1 else max(SeatNo)+1 end from Tbl_ExamseatLayout where Venue=@Venue  and    
  (                
    ( @FromTime  between FromTime and ToTime)  or              
    (      
     (      
    @ToTime between FromTime and ToTime      
      )       
      and       
     @ToTime  != FromTime )        
      or              
      (      
       FromTime>=@FromTime ) and ToTime<=@ToTime ) ),@StudentId,@FromTime,@ToTime,@Created_By,GETDATE(),0)             
              
end      
else  
begin   
Update Tbl_ExamseatLayout set Venue=@Venue,SeatNo=@SeatNo,FromTime=@FromTime,ToTime=@ToTime where  Exam_Id=@Exam_Id and studentId=@StudentId   
end  
end  
end    
    if(@flag=2)    
 begin  select *    
  from Tbl_ExamseatLayout    where Venue=@Venue and     
  (                
    ( @FromTime  between FromTime and ToTime)  or              
    (      
     (      
    @ToTime between FromTime and ToTime      
      )       
      and       
     @ToTime  != FromTime )        
      or              
      (      
       FromTime>=@FromTime ) and ToTime<=@ToTime )     
    end    
     
       
End  
    ')
END
