IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[proc_course_deptment_id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure [dbo].[proc_course_deptment_id] --10,22 
@Department_Id bigint,
@Course_Category_Id BIGINT
as  
begin  
    
  select  *  from Tbl_Course_Department   
  where   
  Department_Id=@Department_Id and Course_Category_Id=@Course_Category_Id  
  end
    ')
END
