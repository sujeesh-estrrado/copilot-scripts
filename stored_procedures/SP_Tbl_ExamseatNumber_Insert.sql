IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_ExamseatNumber_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[SP_Tbl_ExamseatNumber_Insert]              
   (  
   @SeatNoId bigint ,  
   @SeatNo varchar(50)  ,            
   @Room_Id bigint ,  
   @flag bigint=0     
   )              
AS           
          
           
BEGIN    
if(@flag=0)              
 begin           
 SET NOCOUNT ON;  
     INSERT INTO Tbl_ExamseatNumber (SeatNo,Room_Id,Delete_Status) Values(@SeatNo ,@Room_Id,0)  
 SELECT SCOPE_IDENTITY()  
 end   
  
 if(@flag=1)  
 begin  
 update Tbl_ExamseatNumber set Delete_Status=1 where Room_Id=@Room_Id and SeatNoId=@SeatNoId  
 end  
END     
    ')
END
