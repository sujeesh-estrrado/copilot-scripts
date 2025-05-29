IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_student_with_course]')
    AND type = N'P'
)
BEGIN
    EXEC('
create procedure [dbo].[Sp_Get_student_with_course](@Status varchar(50))
as
begin
SELECT        dbo.Tbl_Candidate_Personal_Det.Candidate_Id AS ID, dbo.Tbl_Candidate_Personal_Det.Candidate_Fname + '' '' + dbo.Tbl_Candidate_Personal_Det.Candidate_Lname AS candidatename, 
                         dbo.tbl_approval_log.Offerletter_status AS offerletter, REPLACE(dbo.Tbl_Candidate_Personal_Det.ApplicationStatus, ''_'', '' '') AS ApplicationStatus, dbo.Tbl_Candidate_ContactDetails.Candidate_Email, 
                         dbo.Tbl_Candidate_ContactDetails.Candidate_Mob1, dbo.Tbl_Candidate_Personal_Det.Candidate_Fname, dbo.Tbl_Candidate_Personal_Det.Candidate_Mname, dbo.Tbl_Candidate_Personal_Det.AdharNumber, 
                         dbo.Tbl_Candidate_Personal_Det.ApplicationStatus AS Expr1, dbo.tbl_approval_log.Approved_by, dbo.tbl_approval_log.Verified_by, dbo.Tbl_Department.Department_Name, dbo.Tbl_Course_Category.Course_Category_Name, 
                         dbo.Tbl_Student_CourseSubject_Mapping.Student_Subject_Id
FROM            dbo.Tbl_Candidate_Personal_Det LEFT OUTER JOIN
                         dbo.tbl_approval_log ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.tbl_approval_log.candidate_id INNER JOIN
                         dbo.Tbl_Candidate_ContactDetails ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Candidate_ContactDetails.Candidate_Id INNER JOIN
                         dbo.tbl_New_Admission ON dbo.Tbl_Candidate_Personal_Det.New_Admission_Id = dbo.tbl_New_Admission.New_Admission_Id INNER JOIN
                         dbo.Tbl_Course_Category ON dbo.tbl_New_Admission.Course_Category_Id = dbo.Tbl_Course_Category.Course_Category_Id INNER JOIN
                         dbo.Tbl_Department ON dbo.tbl_New_Admission.Department_Id = dbo.Tbl_Department.Department_Id INNER JOIN
                         dbo.Tbl_Student_CourseSubject_Mapping ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Student_CourseSubject_Mapping.Student_Id
WHERE        (dbo.Tbl_Candidate_Personal_Det.ApplicationStatus = @Status) AND (dbo.Tbl_Candidate_Personal_Det.Candidate_DelStatus = 0)
end
    ')
END;
