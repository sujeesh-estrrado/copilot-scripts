IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_Programs_By_FacultyID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
  CREATE procedure [dbo].[sp_Get_Programs_By_FacultyID]
(
@Course_Level_Id bigint =0
)
as
begin
	SELECT		dbo.Tbl_Department.Department_Id, dbo.Tbl_Department.Department_Name,dbo.Tbl_Department.Course_Code,
				 dbo.Tbl_Course_Level.Course_Level_Id, dbo.Tbl_Department.Active_Status, dbo.Tbl_Department.Delete_Status
	FROM            dbo.Tbl_Course_Level INNER JOIN
							 dbo.Tbl_Department ON dbo.Tbl_Course_Level.Course_Level_Id = dbo.Tbl_Department.GraduationTypeId
	where			Course_Level_Id = @Course_Level_Id
end
	');
END;
