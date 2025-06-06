IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_ExamseatLayout_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[SP_Tbl_ExamseatLayout_Insert]                
   (    
   @Exam_Id bigint ,    
   @Venue bigint  ,              
   @SeatNo bigint ,    
   @StudentId bigint,  
   @from datetime=null,  
   @to datetime=null,  
   @Created_By bigint,  
   @flag bigint=0       
   )                
AS             
            
             
BEGIN      
if(@flag=0)                
 begin             
 SET NOCOUNT ON;    
     INSERT INTO Tbl_ExamseatLayout (Exam_Id,Venue,SeatNo,StudentId,FromTime,ToTime,Created_By,Created_Date,Delete_Status) Values(@Exam_Id ,@Venue,@SeatNo,@StudentId,@from,@to,@Created_By,GETDATE(),0)    
 SELECT SCOPE_IDENTITY()    
 end     
  
END    
    ')
END
