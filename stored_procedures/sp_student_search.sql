IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_student_search]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_student_search]
        @search_term VARCHAR(MAX),
        @employeeid BIGINT = 0
        AS
        BEGIN
            IF (@search_term != '''')
            BEGIN
                SELECT 
                    CPD.Candidate_Id, 
                    CPD.IdentificationNo, 
                    CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Mname, '' '', CPD.Candidate_Lname) AS StudentName, 
                    CPD.Candidate_Dob, 
                    CPD.Candidate_Img,
                    S.name, 
                    CPD.Initial_Application_Id, 
                    CPD.New_Admission_Id, 
                    CPD.AdharNumber AS ICPassport, 
                    CPD.AdmissionType, 
                    CPD.RegDate, 
                    CPD.Campus, 
                    CPD.TypeOfStudent, 
                    CPD.Status, 
                    CPD.CounselorCampus, 
                    CPD.Active_Status, 
                    CPD.IDMatrixNo, 
                    CPD.ApplicationStatus, 
                    CPD.FeeStatus, 
                    CPD.Mode_Of_Study, 
                    CPD.Edit_status, 
                    dbo.Tbl_Student_Semester.Candidate_Id AS Expr1, 
                    bd.Batch_Id, 
                    cs.Semester_Id, 
                    cs.Semester_Name, 
                    bd.Batch_Code, 
                    D.Department_Name AS Program, 
                    D.Course_Code AS ProgramCode, 
                    CL.Course_Level_Name, 
                    D.Department_Id, 
                    S.name AS statusinbarracuda
                FROM dbo.Tbl_Candidate_Personal_Det AS CPD
                INNER JOIN Tbl_Student_status S ON s.id = CPD.active
                LEFT JOIN Tbl_Candidate_ContactDetails CC ON CC.Candidate_Id = CPD.Candidate_Id
                LEFT OUTER JOIN tbl_New_Admission n ON n.New_Admission_Id = CPD.New_Admission_Id
                LEFT JOIN dbo.Tbl_Student_Semester ON dbo.Tbl_Student_Semester.Candidate_Id = CPD.Candidate_Id
                LEFT OUTER JOIN dbo.Tbl_Course_Batch_Duration AS bd ON n.Batch_Id = bd.Batch_Id
                LEFT OUTER JOIN Tbl_Student_Semester SS ON SS.Candidate_Id = CPD.Candidate_Id
                LEFT JOIN dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = SS.SemesterId
                LEFT OUTER JOIN dbo.Tbl_Course_Department AS Cdep ON Cdep.Department_Id = n.Department_Id
                LEFT OUTER JOIN dbo.Tbl_Department AS D ON D.Department_Id = Cdep.Department_Id
                LEFT OUTER JOIN dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = D.GraduationTypeId
                WHERE 
                    (
                        ([Candidate_Fname] LIKE CONCAT(''%'', @search_term, ''%''))
                        OR ([Candidate_Lname] LIKE CONCAT(''%'', @search_term, ''%''))
                        OR ([AdharNumber] LIKE CONCAT(''%'', @search_term, ''%''))
                        OR (IDMatrixNo LIKE CONCAT(''%'', @search_term, ''%''))
                        OR (CONCAT(Candidate_Fname, '' '', Candidate_Lname) LIKE CONCAT(''%'', @search_term, ''%''))
                    )
                    AND (S.id = 3 OR S.id = 2) 
                    AND CL.Faculty_dean_id = @employeeid
            END
        END
    ')
END
