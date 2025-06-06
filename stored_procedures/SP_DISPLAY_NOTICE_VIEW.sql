IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_DISPLAY_NOTICE_VIEW]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE PROCEDURE [dbo].[SP_DISPLAY_NOTICE_VIEW]

    @Notice_Id BIGINT = NULL  
   

as
BEGIN
    SELECT 
    ROW_NUMBER() OVER (ORDER BY n.Notice_Id DESC) AS SlNo,
    n.Createdate,
    n.Subject,
    n.Annoncement,
    n.Notice_Id,
    n.Notice_Doc,
    n.Notify_Urgently,
    n.Notify_Email,
    n.Select_All_Students,

    -- Aggregated fields
    Fac.Faculty,
    Prog.Program,
    Intake.Intake,
    Stud.Students,
    Dept.Departments,
    Role.Roles,
    Emp.Employees,
    Link.LinkName
    

FROM tbl_Notice_Board AS n

-- Faculty
OUTER APPLY (
    SELECT STRING_AGG(FacultyName, '', '') AS Faculty
    FROM (
        SELECT DISTINCT Fc.Course_Level_Name AS FacultyName
        FROM Notice_Faculty_Maping NF
        INNER JOIN Tbl_Course_Level Fc ON NF.Faculty_Id = Fc.Course_Level_Id
        WHERE NF.Notice_Id = n.Notice_Id
    ) AS Sub
) AS Fac

-- Program
OUTER APPLY (
    SELECT STRING_AGG(ProgramName, '', '') AS Program
    FROM (
        SELECT DISTINCT PR.Department_Name AS ProgramName
        FROM Notice_Program_Maping NP
        INNER JOIN Tbl_Department PR ON NP.Program_Id = PR.Department_Id
        WHERE NP.Notice_Id = n.Notice_Id
    ) AS Sub
) AS Prog

-- Intake
OUTER APPLY (
    SELECT STRING_AGG(IntakeCode, '', '') AS Intake
    FROM (
        SELECT DISTINCT IT.Batch_Code AS IntakeCode
        FROM Notice_Intake_Maping NI
        INNER JOIN Tbl_Course_Batch_Duration IT ON NI.Intake_Id = IT.Batch_Code
        WHERE NI.Notice_Id = n.Notice_Id
    ) AS Sub
) AS Intake

-- Students
-- If including SelectAllStudents logic
OUTER APPLY (
    SELECT STRING_AGG(StudentName, '', '') AS Students
    FROM (
        SELECT DISTINCT CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS StudentName
        FROM 
         dbo.Tbl_Candidate_Personal_Det AS CPD
        INNER JOIN Tbl_Student_status S ON S.id = CPD.active
        LEFT JOIN Tbl_Candidate_ContactDetails CC ON CC.Candidate_Id = CPD.Candidate_Id
        LEFT OUTER JOIN tbl_New_Admission A ON A.New_Admission_Id = CPD.New_Admission_Id
        WHERE
            n.Select_All_Students = 1
            OR CPD.Candidate_Id IN (
                SELECT Student_Id 
                FROM Notice_Student_Maping 
                WHERE Notice_Id = n.Notice_Id
            )
    ) AS Sub
) AS Stud


-- Departments
OUTER APPLY (
    SELECT STRING_AGG(DeptName, '', '') AS Departments
    FROM (
        SELECT DISTINCT DP.Dept_Name AS DeptName
        FROM Notice_Department_Maping ND
        INNER JOIN Tbl_Emp_Department DP ON ND.Department_Id = DP.Dept_Id
        WHERE ND.Notice_Id = n.Notice_Id
    ) AS Sub
) AS Dept

-- Roles
OUTER APPLY (
    SELECT STRING_AGG(RoleName, '', '') AS Roles
    FROM (
        SELECT DISTINCT R.Role_Name AS RoleName
        FROM Notice_Role_Maping NR
        INNER JOIN Tbl_Role R ON NR.Role_Id = R.Role_Id
        WHERE NR.Notice_Id = n.Notice_Id
    ) AS Sub
) AS Role

-- Employees
-- Employees
OUTER APPLY (
    SELECT STRING_AGG(EmployeeName, '', '') AS Employees
    FROM (
        SELECT DISTINCT CONCAT(E.Employee_FName, '' '', E.Employee_LName) AS EmployeeName
        FROM Tbl_Employee E
        WHERE 
            (n.Select_All_Employee = 1)
            OR E.Employee_Id IN (
                SELECT EU.Employee_Id
                FROM Notice_Employee_Maping NE
                INNER JOIN Tbl_Employee_User EU ON NE.Employee_Id = EU.User_Id
                WHERE NE.Notice_Id = n.Notice_Id
            )
    ) AS Sub
) AS Emp

OUTER APPLY (
    SELECT STRING_AGG(LinkName, '', '') AS LinkName
    FROM (
        SELECT DISTINCT NL.Link_Id AS LinkName
        FROM Notice_Link_Maping NL
        WHERE NL.Notice_Id = n.Notice_Id
    ) AS Sub
) AS Link

WHERE n.Notice_Id = @Notice_Id; 
END

   ')
END;
