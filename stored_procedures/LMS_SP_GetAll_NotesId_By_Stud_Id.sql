IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_GetAll_NotesId_By_Stud_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LMS_SP_GetAll_NotesId_By_Stud_Id]
            @Stud_Id bigint
        AS
        BEGIN
            SET NOCOUNT ON;
            
            SELECT *
            FROM (
                SELECT DISTINCT 
                    N.Note_Id AS Id,  
                    NULL AS Title,  
                    N.Note_Description AS Description,  
                    N.Note_Date AS Date,  
                    NULL AS Due_Date,  
                    N.Stud_Emp_Id AS Emp_Id,  
                    ''Send'' AS Status,  
                    ''Note'' AS Type,  
                    Stud_Emp_Status,  
                    SN.Approval_Status,  
                    CASE 
                        WHEN N.Stud_Emp_Status = 0 THEN C.Candidate_Fname + '' '' + C.Candidate_Mname + '' '' + C.Candidate_Lname  
                        ELSE E.Employee_Fname + '' '' + E.Employee_Lname  
                    END AS FromName  
                FROM LMS_Tbl_Notes N
                INNER JOIN LMS_Tbl_Send_Notes SN ON SN.Note_Id = N.Note_Id  
                LEFT JOIN Tbl_Candidate_Personal_Det C ON C.Candidate_Id = N.Stud_Emp_Id  
                LEFT JOIN Tbl_Employee E ON E.Employee_Id = N.Stud_Emp_Id  
                WHERE N.Stud_Emp_Id = @Stud_Id 
                AND N.Stud_Emp_Status = 1 
                AND SN.Approval_Status = 0  

                UNION  

                SELECT DISTINCT  
                    N.Note_Id AS Id,  
                    NULL AS Title,  
                    N.Note_Description AS Description,  
                    N.Note_Date AS Date,  
                    NULL AS Due_Date,  
                    N.Stud_Emp_Id AS Emp_Id,  
                    ''Receive'' AS Status,  
                    ''Note'' AS Type,  
                    Stud_Emp_Status,  
                    SN.Approval_Status,  
                    CASE  
                        WHEN N.Stud_Emp_Status = 0 THEN C.Candidate_Fname + '' '' + C.Candidate_Mname + '' '' + C.Candidate_Lname  
                        ELSE E.Employee_Fname + '' '' + E.Employee_Lname  
                    END AS FromName  
                FROM LMS_Tbl_Notes N
                INNER JOIN LMS_Tbl_Send_Notes SN ON SN.Note_Id = N.Note_Id  
                LEFT JOIN Tbl_Candidate_Personal_Det C ON C.Candidate_Id = SN.Stud_Emp_Class_Id  
                LEFT JOIN Tbl_Employee E ON E.Employee_Id = N.Stud_Emp_Id  
                WHERE (SN.Stud_Emp_Class_Id = @Stud_Id AND SN.Stud_Emp_Class_Status = 0)  
                    OR (SN.Stud_Emp_Class_Status = 2 AND SN.Stud_Emp_Class_Id IN  
                        (SELECT Class_Id FROM LMS_Tbl_Student_Class WHERE Student_id = @Stud_Id)  
                    AND N.Stud_Emp_Id <> @Stud_Id)  

                UNION  

                SELECT DISTINCT  
                    SA.Assignment_Id AS Id,  
                    A.Assignment_Title AS Title,  
                    A.Assignment_Desc AS Description,  
                    A.Assignment_Date AS Date,  
                    A.Due_Date,  
                    A.Emp_Id AS Emp_Id,  
                    ''Receive'' AS Status,  
                    ''Assignment'' AS Type,  
                    ''True'' AS Approval_Status,  
                    CAST(1 AS BIT) AS Stud_Emp_Status,  
                    E.Employee_Fname + '' '' + E.Employee_Lname AS FromName  
                FROM LMS_Tbl_Send_Assignment SA  
                INNER JOIN LMS_Tbl_Assignment A ON SA.Assignment_Id = A.Assignment_Id  
                LEFT JOIN Tbl_Employee E ON E.Employee_Id = A.Emp_Id  
                WHERE SA.Stud_Class_Id = @Stud_Id AND SA.Stud_Class_Status = 0  
                    OR (SA.Stud_Class_Status = 1 AND SA.Stud_Class_Id IN  
                        (SELECT Class_Id FROM LMS_Tbl_Student_Class WHERE Student_id = @Stud_Id))  

                UNION  

                SELECT DISTINCT  
                    P.Poll_id AS Id,  
                    NULL AS Title,  
                    P.Poll_Question AS Description,  
                    PS.Poll_Date AS Date,  
                    NULL AS Due_Date,  
                    P.Emp_Id AS Emp_Id,  
                    ''Receive'' AS Status,  
                    ''Poll'' AS Type,  
                    ''True'' AS Approval_Status,  
                    CAST(1 AS BIT) AS Stud_Emp_Status,  
                    E.Employee_Fname + '' '' + E.Employee_Lname AS FromName  
                FROM LMS_Tbl_Poll_Send PS  
                INNER JOIN LMS_Tbl_Poll P ON PS.Poll_id = P.Poll_id  
                LEFT JOIN Tbl_Employee E ON E.Employee_Id = P.Emp_Id  
                WHERE PS.Class_Id IN  
                    (SELECT Class_Id FROM LMS_Tbl_Student_Class WHERE Student_id = @Stud_Id)  

                UNION  

                SELECT DISTINCT  
                    E.Exams_Id AS Id,  
                    NULL AS Title,  
                    E.Exam_Name AS Description,  
                    E.Exam_Date AS Date,  
                    Exam_Due_Date AS Due_Date,  
                    E.Emp_Id AS Emp_Id,  
                    ''Receive'' AS Status,  
                    ''Exam'' AS Type,  
                    ''True'' AS Approval_Status,  
                    CAST(1 AS BIT) AS Stud_Emp_Status,  
                    EMP.Employee_Fname + '' '' + EMP.Employee_Lname AS FromName  
                FROM LMS_Tbl_Exam_Send ES  
                INNER JOIN LMS_Tbl_Exams E ON ES.Exams_Id = E.Exams_Id  
                LEFT JOIN Tbl_Employee EMP ON EMP.Employee_Id = E.Emp_Id  
                WHERE ES.Student_Class_Id = @Stud_Id AND ES.Student_Class_Status = 0  
                    OR (ES.Student_Class_Status = 1 AND ES.Student_Class_Id IN  
                        (SELECT Class_Id FROM LMS_Tbl_Student_Class WHERE Student_id = @Stud_Id))  

                UNION  

                SELECT DISTINCT  
                    Q.Quiz_Id AS Id,  
                    NULL AS Title,  
                    Q.Quiz_Name AS Description,  
                    Q.Quiz_Date AS Date,  
                    Quiz_Due_Date AS Due_Date,  
                    Q.Emp_Id AS Emp_Id,  
                    ''Receive'' AS Status,  
                    ''Quiz'' AS Type,  
                    ''True'' AS Approval_Status,  
                    CAST(1 AS BIT) AS Stud_Emp_Status,  
                    EMP.Employee_Fname + '' '' + EMP.Employee_Lname AS FromName  
                FROM LMS_Tbl_Quiz_Send QS  
                INNER JOIN LMS_Tbl_Quiz Q ON QS.Quiz_Id = Q.Quiz_Id  
                LEFT JOIN Tbl_Employee EMP ON EMP.Employee_Id = Q.Emp_Id  
                WHERE QS.Student_Class_Id = @Stud_Id AND QS.Student_Class_Status = 0  
                    OR (QS.Student_Class_Status = 1 AND QS.Student_Class_Id IN  
                        (SELECT Class_Id FROM LMS_Tbl_Student_Class WHERE Student_id = @Stud_Id))  
            ) AS Post  
            ORDER BY Date DESC;
        END
    ')
END
