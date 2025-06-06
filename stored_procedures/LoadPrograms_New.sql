IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LoadPrograms_New]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[LoadPrograms_New]

@Faculty bigint=0,
@CourseLevel bigint=0
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here


 select D.Department_Id,D.Department_Name,D.Department_Id DeptId from Tbl_Department d
left join Tbl_Course_Level fac on fac.Course_Level_Id = d.GraduationTypeId
left join Tbl_Course_Category cl on cl.Course_Category_Id= d.Program_Type_Id
WHERE d.GraduationTypeId=@Faculty and d.Program_Type_Id=@CourseLevel
END
   ')
END;
