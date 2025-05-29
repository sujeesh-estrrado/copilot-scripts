IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_ModularCourseOperations]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_ModularCourseOperations]
@flag int ,
@courseid bigint = '''',
@courseName nvarchar(500) = '''',
@courseCode nvarchar (500) = ''''

AS
BEGIN

if(@flag = 1)
begin

insert into tbl_Modular_Courses
(CourseName,CourseCode,Isdeleted) values (@courseName,@courseCode,0);
end

--delete a record
if(@flag = 2)
begin

 DECLARE @Result INT;

    IF EXISTS (
        SELECT 1
        FROM Tbl_Modular_Candidate_Details
        WHERE Modular_Course_Id = @CourseId AND Delete_Status = 0
    )
    BEGIN 
        SET @Result = -1;
    END
    ELSE
    BEGIN
UPDATE tbl_Modular_Courses SET Isdeleted = 1 WHERE Id = @courseid;
  SET @Result = 1;
    END

    SELECT @Result AS Result;
    
end

--select a specific record by id
if(@flag = 3)
begin
select * from tbl_Modular_Courses where Isdeleted = 0 AND Id = @courseid;
end

--update a record 
if(@flag = 4)
begin
UPDATE tbl_Modular_Courses SET CourseName = @courseName,CourseCode = @courseCode
WHERE Id = @courseid;
end

if(@flag = 5)
begin
Select Id,CourseName,CourseCode from tbl_Modular_Courses where Isdeleted = 0 and (Id = @courseid OR @courseid = '''')
end

END
    ')
END;
