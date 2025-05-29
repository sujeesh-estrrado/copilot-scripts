IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Course_Level]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_Insert_Course_Level]       
 (@course_level_name varchar(300),@course_level_Descripition varchar(500),@course_level_date DateTime)      
AS      
IF EXISTS(SELECT Course_level_name FROM Tbl_Course_Level Where Course_level_name = @course_level_name and Course_Level_Status=0)      
BEGIN      
RAISERROR (''Data Already Exists.'', -- Message text.      
               16, -- Severity.      
               1 -- State.      
               );      
END      
ELSE      
      
       
BEGIN       
       
  insert into Tbl_Course_Level(Course_level_name,Course_level_Descripition,Course_level_date)      
  values(@course_level_name,@course_level_Descripition,@course_level_date)      
      
 SELECT SCOPE_IDENTITY()      
END');
END;
