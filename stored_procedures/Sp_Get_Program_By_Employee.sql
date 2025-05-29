IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_Program_Count]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE  procedure [dbo].[sp_Get_Program_Count]
@flag int =0,
@facultyId int,
@programTypeId int
AS                  
BEGIN 
	if @flag = 0 --Total Count of Programs
		begin
			select COUNT(*) from Tbl_Department where Department_Status = 0 and Delete_Status = 0
		end
	if @flag = 1 --Count of Programs of a Faculty
		begin
			select COUNT(*) from Tbl_Department where GraduationTypeId = @facultyId and Department_Status = 0 and Delete_Status = 0
		end
	if @flag = 2 --Count of Programs of a ProgramType
		begin
			SELECT        count(*)
			FROM            dbo.Tbl_Course_Department INNER JOIN
                         dbo.Tbl_Department ON dbo.Tbl_Course_Department.Department_Id = dbo.Tbl_Department.Department_Id
			where          dbo.Tbl_Department.Department_Status = 0 and dbo.Tbl_Department.Delete_Status = 0
                          and dbo.Tbl_Course_Department.Course_Category_Id = @programTypeId
		end
end
    ')
END
GO
