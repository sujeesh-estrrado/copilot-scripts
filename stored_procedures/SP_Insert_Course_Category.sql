IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Course_Category]') 
    AND type = N'P'
)
BEGIN
    EXEC('
          
CREATE procedure [dbo].[SP_Insert_Course_Category]           
 (@Course_level_Id bigint,@course_category_name varchar(300),@course_category_Descripition varchar(500),@course_category_date datetime,
 @ProgramCode varchar(50),@ProgramEmail varchar(50),@ProgramDirector varchar(50))            
AS            
 IF EXISTS(SELECT Course_category_name,Program_Code FROM Tbl_Course_Category Where Course_category_name = @course_category_name or Program_Code=@ProgramCode)            
BEGIN            
RAISERROR (''Data Already Exists.'', -- Message text.            
               16, -- Severity.            
               1 -- State.            
               );            
END            
ELSE            
BEGIN            
             
  insert into Tbl_Course_Category(Course_level_Id,Course_category_name,Course_category_Descripition,Course_category_date,
 Program_Code,Program_Email,Program_Director)            
  values(@Course_level_Id,@course_category_name,@course_category_Descripition,@course_category_date,
   @ProgramCode,@ProgramEmail,@ProgramDirector)             
            
             
END');
END;
