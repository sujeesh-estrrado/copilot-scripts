IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_ProgramsIntake_By_FacultyID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_Get_ProgramsIntake_By_FacultyID]  
(  
@Course_Level_Id bigint =0  
)  
as  
begin  
 SELECT        Dept.Department_Id, Dept.Department_Name, Dept.Course_Code, CL.Course_Level_Id, Dept.Active_Status,  
     Dept.Delete_Status, dbo.Tbl_Course_Batch_Duration.Batch_Code, Batch_Id  
  
FROM            dbo.Tbl_Course_Level AS CL INNER JOIN  
                         dbo.Tbl_Department AS Dept ON CL.Course_Level_Id = Dept.GraduationTypeId INNER JOIN  
                         dbo.Tbl_Course_Batch_Duration ON Dept.Department_Id = dbo.Tbl_Course_Batch_Duration.Duration_Id  
WHERE        (CL.Course_Level_Id = @Course_Level_Id or @Course_Level_Id = 0) and (Tbl_Course_Batch_Duration.Batch_DelStatus=0)  
order by Tbl_Course_Batch_Duration.Batch_Code desc
end
	');
END;
