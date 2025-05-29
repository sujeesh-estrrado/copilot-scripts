IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Modular_CourseCode]') 
    AND type = N'P'
)
BEGIN
    EXEC('


create procedure [dbo].[SP_Get_Modular_CourseCode]                                
 @CourseId BIGINT                               
AS                                
                                
BEGIN                         
             
    SELECT  CourseCode FROM tbl_Modular_Courses WHERE Id=@CourseId 
                                   
END 
    ')
END;
