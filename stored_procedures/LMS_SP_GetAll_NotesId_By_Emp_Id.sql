IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_GetAll_NotesId_By_Emp_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LMS_SP_GetAll_NotesId_By_Emp_Id]  
            @Emp_Id BIGINT
        AS  
        BEGIN  
            SET NOCOUNT ON;  

            SELECT * FROM (  
                -- Sent Notes  
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
                    CASE WHEN N.Stud_Emp_Status = 0 THEN 
                        C.Candidate_Fname + '' '' + C.Candidate_Mname + '' '' + C.Candidate_Lname  
                    ELSE 
                        E.Employee_Fname + '' '' + E.Employee_Lname  
                    END AS FromName  
                FROM LMS_Tbl_Notes N  
                INNER JOIN LMS_Tbl_Send_Notes SN ON SN.Note_Id = N.Note_Id  
                LEFT JOIN Tbl_Candidate_Personal_Det C ON C.Candidate_Id = N.Stud_Emp_Id  
                LEFT JOIN Tbl_Employee E ON E.Employee_Id = N.Stud_Emp_Id  
                WHERE N.Stud_Emp_Id = @Emp_Id  
                    AND N.Stud_Emp_Status = 0  
                    AND SN.Approval_Status = 0  

                UNION  

                -- Received Notes  
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
                    CASE WHEN N.Stud_Emp_Status = 0 THEN 
                        C.Candidate_Fname + '' '' + C.Candidate_Mname + '' '' + C.Candidate_Lname  
                    ELSE 
                        E.Employee_Fname + '' '' + E.Employee_Lname  
                    END AS FromName  
                FROM LMS_Tbl_Notes N  
                INNER JOIN LMS_Tbl_Send_Notes SN ON SN.Note_Id = N.Note_Id  
                LEFT JOIN Tbl_Candidate_Personal_Det C ON C.Candidate_Id = N.Stud_Emp_Id  
                LEFT JOIN Tbl_Employee E ON E.Employee_Id = N.Stud_Emp_Id  
                WHERE (SN.Stud_Emp_Class_Id = @Emp_Id AND SN.Stud_Emp_Class_Status = 1)  
                    OR (SN.Stud_Emp_Class_Status = 2  
                        AND SN.Stud_Emp_Class_Id IN (SELECT Class_Id FROM LMS_Tbl_Emp_Class WHERE Emp_Id = @Emp_Id)  
                        AND N.Stud_Emp_Id <> @Emp_Id)  

                UNION  

                -- Assignments  
                SELECT DISTINCT  
                    A.Assignment_Id AS Id,  
                    Assignment_Title AS Title,  
                    Assignment_Desc AS Description,  
                    Assignment_Date AS Date,  
                    Due_Date,  
                    Emp_Id AS Emp_Id,  
                    ''Send'' AS Status,  
                    ''Assignment'' AS Type,  
                    ''True'' AS Approval_Status,  
                    CAST(1 AS BIT) AS Stud_Emp_Status,  
                    E.Employee_Fname + '' '' + E.Employee_Lname AS FromName  
                FROM LMS_Tbl_Assignment A  
                INNER JOIN LMS_Tbl_Send_Assignment SA ON A.Assignment_Id = SA.Assignment_Id  
                LEFT JOIN Tbl_Employee E ON E.Employee_Id = A.Emp_Id  
                WHERE (Emp_Id = @Emp_Id)  
                    OR (Stud_Class_Status = 1  
                        AND Stud_Class_Id IN (SELECT Class_Id FROM LMS_Tbl_Emp_Class WHERE Emp_Id = @Emp_Id))  

                UNION  

                -- Polls  
                SELECT DISTINCT  
                    P.Poll_id AS Id,  
                    NULL AS Title,  
                    Poll_Question AS Description,  
                    P.Poll_Date AS Date,  
                    NULL AS Due_Date,  
                    Emp_Id AS Emp_Id,  
                    ''Send'' AS Status,  
                    ''Poll'' AS Type,  
                    ''True'' AS Approval_Status,  
                    CAST(1 AS BIT) AS Stud_Emp_Status,  
                    E.Employee_Fname + '' '' + E.Employee_Lname AS FromName  
                FROM LMS_Tbl_Poll P  
                INNER JOIN LMS_Tbl_Poll_Send PS ON P.Poll_id = PS.Poll_id  
                LEFT JOIN Tbl_Employee E ON E.Employee_Id = P.Emp_Id  
                WHERE P.Emp_Id = @Emp_Id  
                    OR (Class_Id IN (SELECT Class_Id FROM LMS_Tbl_Emp_Class WHERE Emp_Id = @Emp_Id))  

                UNION  

                -- Exams  
                SELECT DISTINCT  
                    E.Exams_Id AS Id,  
                    NULL AS Title,  
                    Exam_Name AS Description,  
                    Exam_Send_Date AS Date,  
                    Exam_Due_Date AS Due_Date,  
                    Emp_Id AS Emp_Id,  
                    ''Send'' AS Status,  
                    ''Exam'' AS Type,  
                    ''True'' AS Approval_Status,  
                    CAST(1 AS BIT) AS Stud_Emp_Status,  
                    EMP.Employee_Fname + '' '' + EMP.Employee_Lname AS FromName  
                FROM LMS_Tbl_Exams E  
                INNER JOIN LMS_Tbl_Exam_Send ES ON E.Exams_Id = ES.Exams_Id  
                LEFT JOIN Tbl_Employee EMP ON EMP.Employee_Id = E.Emp_Id  
                WHERE (E.Emp_Id = @Emp_Id)  
                    OR (Student_Class_Status = 1  
                        AND Student_Class_Id IN (SELECT Class_Id FROM LMS_Tbl_Emp_Class WHERE Emp_Id = @Emp_Id))  

                UNION  

                -- Quizzes  
                SELECT DISTINCT  
                    Q.Quiz_Id AS Id,  
                    NULL AS Title,  
                    Quiz_Name AS Description,  
                    Quiz_Send_Date AS Date,  
                    Quiz_Due_Date AS Due_Date,  
                    Emp_Id AS Emp_Id,  
                    ''Send'' AS Status,  
                    ''Quiz'' AS Type,  
                    ''True'' AS Approval_Status,  
                    CAST(1 AS BIT) AS Stud_Emp_Status,  
                    EMP.Employee_Fname + '' '' + EMP.Employee_Lname AS FromName  
                FROM LMS_Tbl_Quiz Q  
                INNER JOIN LMS_Tbl_Quiz_Send QS ON Q.Quiz_Id = QS.Quiz_Id  
                LEFT JOIN Tbl_Employee EMP ON EMP.Employee_Id = Q.Emp_Id  
                WHERE (Q.Emp_Id = @Emp_Id)  
                    OR (Student_Class_Status = 1  
                        AND Student_Class_Id IN (SELECT Class_Id FROM LMS_Tbl_Emp_Class WHERE Emp_Id = @Emp_Id))  

            ) AS Post  
            ORDER BY Date DESC;  
        END
    ')
END
