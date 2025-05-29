IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Program_Type]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Insert_Program_Type]           
 (@course_category_name varchar(300),@course_category_Descripition varchar(500),@course_category_date datetime
 ,@RegFee varchar(10)='''',@RegFeeInter varchar(10)='''',@Prgmcode varchar(10)='''')            
AS            
 IF EXISTS(SELECT Course_category_name FROM Tbl_Course_Category Where Course_category_name = @course_category_name and Delete_Status=0 and Course_Category_Status=0)            
BEGIN            
RAISERROR (''Data Already Exists.'', -- Message text.            
               16, -- Severity.            
               1 -- State.            
               );            
END            
ELSE if EXISTS(SELECT Course_category_name FROM Tbl_Course_Category Where Course_category_name = @course_category_name and Delete_Status=0 and Course_Category_Status=1)        
BEGIN    
        
       update Tbl_Course_Category set Course_Category_Status=''0'',Course_Category_Descripition=@course_category_Descripition,Delete_Status=0,Updated_Date=GETDATE() where Course_Category_Name=@course_category_name;
	   end
	   else  
	   begin    
  insert into Tbl_Course_Category(Course_category_name,Course_category_Descripition,Course_category_date,Updated_Date,Delete_Status,Program_Code)            
  values(@course_category_name,@course_category_Descripition,@course_category_date,@course_category_date,''0'',@Prgmcode)             
        
             
END   ');
END;
