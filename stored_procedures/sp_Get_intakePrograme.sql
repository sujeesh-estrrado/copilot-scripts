IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_intakePrograme]')
    AND type = N'P'
)
BEGIN
    EXEC('
   create procedure [dbo].[sp_Get_intakePrograme](@candidateid bigint)
as
begin

SELECT        dbo.Tbl_Candidate_Personal_Det.Candidate_Id, dbo.Tbl_Course_Batch_Duration.Batch_Id, dbo.Tbl_Course_Batch_Duration.Batch_Code AS intake, dbo.Tbl_Department.Department_Name AS programme,im.id as ID
FROM            dbo.Tbl_Department left JOIN
                         dbo.tbl_New_Admission ON dbo.Tbl_Department.Department_Id = dbo.tbl_New_Admission.Department_Id LEFT OUTER JOIN
                         dbo.Tbl_Course_Level ON dbo.tbl_New_Admission.Course_Level_Id = dbo.Tbl_Course_Level.Course_Level_Id LEFT OUTER JOIN
                         dbo.Tbl_Course_Batch_Duration ON dbo.tbl_New_Admission.Batch_Id = dbo.Tbl_Course_Batch_Duration.Batch_Id RIGHT OUTER JOIN
                         dbo.Tbl_Candidate_Personal_Det ON dbo.tbl_New_Admission.New_Admission_Id = dbo.Tbl_Candidate_Personal_Det.New_Admission_Id 
						 left join Tbl_IntakeMaster im on im.id=Tbl_Course_Batch_Duration.IntakeMasterID and im.DeleteStatus=0
						 where Tbl_Candidate_Personal_Det.Candidate_Id=@candidateid


						 end

    ')
END
