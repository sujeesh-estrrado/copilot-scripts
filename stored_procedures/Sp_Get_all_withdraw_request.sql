IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_all_withdraw_request]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Get_all_withdraw_request]
        @Type VARCHAR(MAX) = '''',
        @id BIGINT = 0,
        @flag BIGINT = 0
        AS
        BEGIN
            IF (@flag > 0)
            BEGIN
                SELECT 
                    CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS Candidate_Name,
                    D.Docname AS doc,
                    ST.Request_status,
                    Employee_Id,
                    ST.Request_status AS Status,
                    CC.Candidate_Email,
                    CPD.Candidate_Id AS ID,
                    D.Path AS url,
                    CL.Course_Level_Name,
                    FORMAT(ST.Create_date, ''dd-MM-yyyy, hh:mm:ss tt '') AS date,
                    ST.Remark AS Remark,
                    ST.faculty_remark,
                    CONCAT(dbo.Tbl_Employee.Employee_FName, '' '', dbo.Tbl_Employee.Employee_LName) AS EmployeeName,
                    cbd.Batch_Code AS intake,
                    De.Department_Name AS courseName,
                    CPD.adharnumber AS icno,
                    CPD.idmatrixno
                FROM 
                    dbo.Tbl_Candidate_Personal_Det AS CPD
                INNER JOIN 
                    dbo.Tbl_Student_Tc_request AS ST ON ST.Candidate_id = CPD.Candidate_Id
                INNER JOIN 
                    dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = ST.Faculty_id
                LEFT JOIN 
                    tbl_new_admission N ON N.new_admission_id = CPD.New_admission_id
                LEFT JOIN 
                    Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = N.Batch_Id
                LEFT JOIN 
                    Tbl_Department De ON De.department_id = N.department_id
                LEFT JOIN 
                    dbo.Tbl_Candidate_ContactDetails AS CC ON CC.Candidate_Id = CPD.Candidate_Id
                LEFT JOIN 
                    dbo.Tbl_Employee ON CL.Faculty_dean_id = dbo.Tbl_Employee.Employee_Id
                LEFT JOIN 
                    Tbl_Defer_Documents D ON ST.Tc_request_id = D.Defer_Request_id AND D.Candidate_id = CPD.Candidate_Id
                WHERE 
                    CPD.Candidate_DelStatus = 0 
                    AND ST.Request_type = @Type  
                    AND (CL.Faculty_dean_id = @id) 
                    AND ST.Delete_status = 0
                ORDER BY 
                    ST.Create_date
            END
            ELSE
            BEGIN
                SELECT 
                    CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS Candidate_Name,
                    D.Docname AS doc,
                    ST.Request_status,
                    Employee_Id,
                    ST.Request_status AS Status,
                    CC.Candidate_Email,
                    CPD.Candidate_Id AS ID,
                    D.Path AS url,
                    CL.Course_Level_Name,
                    FORMAT(ST.Create_date, ''dd-MM-yyyy, hh:mm:ss tt '') AS date,
                    ST.Remark AS Remark,
                    ST.faculty_remark,
                    CONCAT(dbo.Tbl_Employee.Employee_FName, '' '', dbo.Tbl_Employee.Employee_LName) AS EmployeeName,
                    cbd.Batch_Code AS intake,
                    De.Department_Name AS courseName,
                    CPD.adharnumber AS icno,
                    CPD.idmatrixno
                FROM 
                    dbo.Tbl_Candidate_Personal_Det AS CPD
                INNER JOIN 
                    dbo.Tbl_Student_Tc_request AS ST ON ST.Candidate_id = CPD.Candidate_Id
                INNER JOIN 
                    dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = ST.Faculty_id
                LEFT JOIN 
                    tbl_new_admission N ON N.new_admission_id = CPD.New_admission_id
                LEFT JOIN 
                    Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = N.Batch_Id
                LEFT JOIN 
                    Tbl_Department De ON De.department_id = N.department_id
                LEFT JOIN 
                    dbo.Tbl_Candidate_ContactDetails AS CC ON CC.Candidate_Id = CPD.Candidate_Id
                LEFT JOIN 
                    dbo.Tbl_Employee ON CL.Faculty_dean_id = dbo.Tbl_Employee.Employee_Id
                LEFT JOIN 
                    Tbl_Defer_Documents D ON ST.Tc_request_id = D.Defer_Request_id AND D.Candidate_id = CPD.Candidate_Id
                WHERE 
                    CPD.Candidate_DelStatus = 0 
                    AND ST.Request_type = @Type 
                    AND ST.Request_status != ''Approved'' 
                    AND ST.Delete_status = 0  
                    AND (CL.Faculty_dean_id = @id)
                ORDER BY 
                    ST.Create_date
            END
        END
    ')
END
