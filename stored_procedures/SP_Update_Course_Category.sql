IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Course_Category]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Update_Course_Category](@Course_Category_Id bigint,@Course_level_Id bigint,@Course_Category_Name varchar(300),    
     @Course_Category_Descripition varchar(500),@Course_Category_Date datetime,
     @ProgramCode varchar(50),@ProgramEmail varchar(50),@ProgramDirector varchar(50))     
    
AS    
  IF EXISTS(SELECT Course_category_name,Program_Code FROM Tbl_Course_Category Where Course_category_name = @course_category_name and Program_Code=@ProgramCode and Course_Category_Id<>@Course_Category_Id )              
BEGIN              
RAISERROR (''Data Already Exists.'', -- Message text.              
               16, -- Severity.              
               1 -- State.              
               );              
END              
ELSE   
BEGIN    
    
 UPDATE [dbo].[Tbl_Course_Category]    
  SET       
               Course_level_Id                   = @Course_level_Id,     
               course_Category_Name              = @Course_Category_Name,    
      course_Category_Descripition      = @Course_Category_Descripition,    
               course_Category_Date              = @Course_Category_Date,  
                Program_Code =@ProgramCode,
                Program_Email  =@ProgramEmail,
                Program_Director  =@ProgramDirector
  WHERE  course_Category_Id                = @Course_Category_Id    
    
END
    ')
END
