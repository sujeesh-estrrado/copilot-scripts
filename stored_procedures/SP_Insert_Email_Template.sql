IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Email_Template]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_Insert_Email_Template]       
 (@Email_Heading varchar(50),
  @Email_Content varchar(max))      
AS      
--IF EXISTS(SELECT Course_level_name FROM Tbl_Course_Level Where Course_level_name = @course_level_name and Course_Level_Status=0)      
--BEGIN      
--RAISERROR (''Data Already Exists.'', -- Message text.      
--               16, -- Severity.      
--               1 -- State.      
--               );      
--END      
--ELSE      
      
       
BEGIN       
       
  insert into dbo.Tbl_Email_Template (Email_Heading,Email_Content)      
  values(@Email_Heading,@Email_Content)      
     
END');
END;
