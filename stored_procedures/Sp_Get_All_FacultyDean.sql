IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_FacultyDean]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_Get_All_FacultyDean] --1
(
@facultyId bigint=0
)
as
BEGIN

    select Course_Level_Id,Course_Level_Name,Faculty_dean_id,MM.Employee_Id,mm.[User_Id] from Tbl_Course_Level 
    left join Tbl_Employee_User AS MM on Faculty_dean_id=MM.Employee_Id where Course_Level_Id=@facultyId
    
END
    ')
END
