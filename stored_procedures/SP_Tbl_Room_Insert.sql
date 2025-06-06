IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Room_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[SP_Tbl_Room_Insert]                
   (@Room_Name varchar(200)                
   ,@Campus_Id bigint                
   ,@Block_Id bigint                
   ,@Floor_Id bigint                
   ,@Seat_Capacity int                
   ,@Exam_SeatCapacity int,          
   @examhall_status bigint)                
AS             
            
            
IF EXISTS(SELECT Room_Name FROM Tbl_Room Where Room_Name = @Room_Name and             
Campus_Id = @Campus_Id and             
Block_Id=@Block_Id and            
Floor_Id=@Floor_Id and            
Room_Status = 0)                  
BEGIN                  
RAISERROR (''Your data already Exist.'', -- Message text.                  
               16, -- Severity.                  
               1 -- State.                  
               );                  
END                  
ELSE              
              
BEGIN       
SET NOCOUNT ON;  
 INSERT INTO [Tbl_Room]                
           ([Room_Name]                
           ,[Campus_Id]                
           ,[Block_Id]                
           ,[Floor_Id]                
           ,[Seat_Capacity]                
           ,[Exam_SeatCapacity],Room_Type)                
     VALUES                
           (@Room_Name                
           ,@Campus_Id                
           ,@Block_Id                
           ,@Floor_Id                
           ,@Seat_Capacity                
           ,@Exam_SeatCapacity,@examhall_status)         
         
     SELECT SCOPE_IDENTITY()    
END     
    ');
END;
