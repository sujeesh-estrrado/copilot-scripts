IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Examseatnumber]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE  procedure [dbo].[SP_Get_Examseatnumber]                
   (     
   @Venue bigint  ,   
   @flag bigint=0       
   )                
AS             
            
             
BEGIN      
if(@flag=0)                
 begin             
   select SeatNoId,SeatNo,Room_Id from Tbl_ExamseatNumber where Room_Id=@Venue and Delete_Status=0  
 end     
  
END            
    
     
    ')
END
