IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Course_Level]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure [dbo].[SP_Update_Course_Level](@Course_Level_Id bigint,@Course_Level_Name varchar(300),    
     @Course_Level_Descripition varchar(500),@Course_Level_Date varchar(50))    
    
AS  
IF EXISTS(SELECT Course_level_name FROM Tbl_Course_Level Where Course_level_name = @course_level_name and Course_Level_Status=0 and Course_Level_Id <> @Course_Level_Id )         
BEGIN          
RAISERROR (''Data Already Exists.'', -- Message text.          
               16, -- Severity.          
               1 -- State.          
               );          
END          
ELSE            
    
BEGIN    
    
 UPDATE [dbo].[Tbl_Course_Level]    
  SET        
               course_Level_Name     = @Course_Level_Name,    
      course_Level_Descripition      = @Course_Level_Descripition,    
               course_Level_Date     = @Course_Level_Date    
                  
                  
  WHERE  course_Level_Id             = @Course_Level_Id    
    
END
    ')
END
