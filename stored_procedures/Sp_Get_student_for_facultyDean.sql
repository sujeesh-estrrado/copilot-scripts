IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_student_for_facultyDean]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[Sp_Get_student_for_facultyDean](@employeeid bigint)
as
begin 
SELECT       concat( dbo.Tbl_Candidate_Personal_Det.Candidate_Fname, '' '',dbo.Tbl_Candidate_Personal_Det.Candidate_Lname) as StudentName,dbo.Tbl_Candidate_Personal_Det.Candidate_Id as  Student_id,dbo.Tbl_Candidate_Personal_Det.Candidate_Dob, dbo.Tbl_Candidate_Personal_Det.AdharNumber
FROM            dbo.Tbl_Candidate_Personal_Det INNER JOIN
                         dbo.tbl_New_Admission ON dbo.Tbl_Candidate_Personal_Det.New_Admission_Id = dbo.tbl_New_Admission.New_Admission_Id inner join  Tbl_Course_Level on tbl_New_Admission.Course_Level_Id=Tbl_Course_Level.Course_Level_Id where ApplicationStatus=''Completed'' and Delete_Status=0 and Tbl_Course_Level.Faculty_dean_id=@employeeid;
end    ');
END;
