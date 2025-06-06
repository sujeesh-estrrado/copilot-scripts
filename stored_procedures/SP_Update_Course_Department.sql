IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Course_Department]') 
    AND type = N'P'
)
BEGIN
    EXEC('
               
CREATE procedure [dbo].[SP_Update_Course_Department](@Course_Department_Id bigint,@Course_Category_Id bigint,@Department_Id bigint,        
     @Course_Department_Description varchar(500),@Course_Department_Date datetime,@ProviderCode bigint)        
        
AS        
        
--IF EXISTS(SELECT * from Tbl_Course_Department  Where Department_Id=@Department_Id and Course_Category_Id=@Course_Category_Id and Course_Department_Status=0 and Course_Department_Id<>@Course_Department_Id  )            
-- BEGIN            
-- RAISERROR (''Data Already Exists.'', -- Message text.            
--       16, -- Severity.            
--       1 -- State.            
--       );            
-- END            
--ELSE       
      
BEGIN        
        
 UPDATE [dbo].[Tbl_Course_Department]        
  SET          
        
        
               Course_Category_Id =@Course_Category_Id,          
               Department_Id= @Department_Id,        
               course_Department_Description= @Course_Department_Description,        
               course_Department_Date= @Course_Department_Date ,       
               ProviderId =@ProviderCode    
                      
  WHERE   Course_Department_Id= @Course_Department_Id        
        
END
    ')
END
