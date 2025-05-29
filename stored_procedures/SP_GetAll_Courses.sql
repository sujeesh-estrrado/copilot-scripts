IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Courses]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[SP_GetAll_Courses]                                
                                
AS                                
                                
BEGIN                         
             
    SELECT Id AS CourseId,CourseName FROM tbl_Modular_Courses where Isdeleted=0      
                                   
END 
    ')
END;
