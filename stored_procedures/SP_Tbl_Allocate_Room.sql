IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Allocate_Room]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Tbl_Allocate_Room]      
   (@Room_Id bigint        
   ,@Duration_Mapping_Id bigint )        
AS        
     
if exists (select * from Tbl_Class_Allocation  where Room_Id= @Room_Id and Duration_Mapping_Id =@Duration_Mapping_Id)    
BEGIN      
  RAISERROR (''Your data already Exist.'', -- Message text.      
               16, -- Severity.      
               1 -- State.      
               );      
END      
ELSE    
BEGIN     
 INSERT INTO Tbl_Class_Allocation       
           (Room_Id,Duration_Mapping_Id)        
     VALUES        
           (@Room_Id        
           ,@Duration_Mapping_Id)        
END
   ')
END;
