IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Program_Type]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Update_Program_Type](@Course_Category_Id bigint,@Course_Category_Name varchar(300),    
     @Course_Category_Descripition varchar(500),@RegFee varchar(10)='''',@RegFeeInter varchar(10)='''',@Prgmcode varchar(10)='''')      
    
AS    
  IF EXISTS(SELECT Course_category_name FROM Tbl_Course_Category Where Course_category_name = @course_category_name and Course_Category_Id<>@Course_Category_Id )              
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
               course_Category_Name              = @Course_Category_Name,    
      course_Category_Descripition      = @Course_Category_Descripition,    
               Updated_Date              = GETDATE(),
               Program_Code =       @Prgmcode
  WHERE  course_Category_Id                = @Course_Category_Id    
END

    ')
END;
