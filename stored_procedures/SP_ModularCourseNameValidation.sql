IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_ModularCourseNameValidation]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_ModularCourseNameValidation]
@ModularCourseName Varchar(200)='''',
 @CourseCode VARCHAR(200) = '''',
@Flag Int
AS
BEGIN

 IF (@Flag = 1)
    BEGIN

  SELECT 
            ISNULL(SUM(CASE WHEN CourseName = @ModularCourseName AND IsDeleted = 0 THEN 1 ELSE 0 END), 0) AS ModularCourseCount,
            ISNULL(SUM(CASE WHEN CourseCode = @CourseCode AND IsDeleted = 0 THEN 1 ELSE 0 END), 0) AS CourseCodeCount
  FROM tbl_Modular_Courses;



END

END
    ')
END;
