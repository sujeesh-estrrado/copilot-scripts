IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[M_COURSE_CODE_DDL]') 
    AND type = N'P'
)
BEGIN
    EXEC('
create PROCEDURE [dbo].[M_COURSE_CODE_DDL] 
(
@courseid bigint =0
)

AS    
BEGIN 
select id,CourseName,CourseCode from tbl_Modular_Courses where Isdeleted=0 and Id=@courseid
END
    ')
END;
