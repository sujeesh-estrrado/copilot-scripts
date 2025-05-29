IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get__CoursesBy_FacultyID]')
    AND type = N'P'
)
BEGIN
    EXEC('
    
CREATE procedure  [dbo].[Sp_Get__CoursesBy_FacultyID]
@facultyid bigint = 0
As
Begin
    --Select Department_Id,Department_Name from  dbo.Tbl_Department where (GraduationTypeId=@facultyid  or @facultyid=0 )and Department_Status=0

    SELECT        D.Department_Id, D.Department_Name, D.Course_Code, D.Active_Status, D.Delete_Status, CL.Course_Level_Name, CL.Course_Level_Id
FROM            dbo.Tbl_Department AS D INNER JOIN
                         dbo.Tbl_Course_Level AS CL ON D.GraduationTypeId = CL.Course_Level_Id
WHERE        (D.Department_Status = 0) AND (D.Delete_Status = 0) AND (D.Active_Status = ''Active'') AND (CL.Course_Level_Id = @facultyid or @facultyid =0)
End
    ')
END
