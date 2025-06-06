IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_GetAll_Post_By_Emp_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LMS_SP_GetAll_Post_By_Emp_Id]  
        @Emp_Id BIGINT  
        AS  
        BEGIN  
            SET NOCOUNT ON;  

            SELECT * FROM (
                -- Notes Sent  
                SELECT  
                    DISTINCT N.Note_Id AS Id,  
                    NULL AS Title,  
                    N.Note_Description AS Description,  
                    N.Note_Date AS Date,  
                    NULL AS Due_Date,  
                    N.Stud_Emp_Id AS Emp_Id,  
                    ''Send'' AS Status,  
                    ''Note'' AS Type,  
                    N.Stud_Emp_Status,  
                    CASE  
                        WHEN N.Stud_Emp_Status = 0  
                        THEN C.Candidate_Fname + '' '' + C.Candidate_Mname + '' '' + C.Candidate_Lname  
                        ELSE E.Employee_Fname + '' '' + E.Employee_Lname  
                    END AS FromName  
                FROM LMS_Tbl_Notes N  
                INNER JOIN LMS_Tbl_Send_Notes SN ON SN.Note_Id = N.Note_Id  
                LEFT JOIN Tbl_Candidate_Personal_Det C ON C.Candidate_Id = N.Stud_Emp_Id  
                LEFT JOIN Tbl_Employee E ON E.Employee_Id = N.Stud_Emp_Id  
                WHERE N.Stud_Emp_Id = @Emp_Id AND N.Stud_Emp_Status = 1  

                UNION  

                -- Notes Received  
                SELECT  
                    DISTINCT N.Note_Id AS Id,  
                    NULL AS Title,  
                    N.Note_Description AS Description,  
                    N.Note_Date AS Date,  
                    NULL AS Due_Date,  
                    N.Stud_Emp_Id AS Emp_Id,  
                    ''Receive'' AS Status,  
                    ''Note'' AS Type,  
                    N.Stud_Emp_Status,  
                    CASE  
                        WHEN N.Stud_Emp_Status = 0  
                        THEN C.Candidate_Fname + '' '' + C.Candidate_Mname + '' '' + C.Candidate_Lname  
                        ELSE E.Employee_Fname + '' '' + E.Employee_Lname  
                    END AS FromName  
                FROM LMS_Tbl_Notes N  
                INNER JOIN LMS_Tbl_Send_Notes SN ON SN.Note_Id = N.Note_Id  
                LEFT JOIN Tbl_Candidate_Personal_Det C ON C.Candidate_Id = N.Stud_Emp_Id  
                LEFT JOIN Tbl_Employee E ON E.Employee_Id = N.Stud_Emp_Id  
                WHERE  
                    (SN.Stud_Emp_Class_Id = @Emp_Id AND SN.Stud_Emp_Class_Status = 1)  
                    OR (SN.Stud_Emp_Class_Status = 2  
                        AND SN.Stud_Emp_Class_Id IN (SELECT Class_Id FROM LMS_Tbl_Emp_Class WHERE Emp_id = @Emp_Id)  
                        AND N.Stud_Emp_Id <> @Emp_Id)  

                UNION  

                -- Assignments  
                SELECT  
                    DISTINCT A.Assignment_Id AS Id,  
                    A.Assignment_Title AS Title,  
                    A.Assignment_Desc AS Description,  
                    A.Assignment_Date AS Date,  
                    A.Due_Date,  
                    A.Emp_Id AS Emp_Id,  
                    ''Send'' AS Status,  
                    ''Assignment'' AS Type,  
                    CAST(1 AS BIT) AS Stud_Emp_Status,  
                    E.Employee_Fname + '' '' + E.Employee_Lname AS FromName  
                FROM LMS_Tbl_Assignment A  
                INNER JOIN LMS_Tbl_Send_Assignment SA ON A.Assignment_Id = SA.Assignment_Id  
                LEFT JOIN Tbl_Employee E ON E.Employee_Id = A.Emp_Id  
                WHERE  
                    A.Emp_Id = @Emp_Id  
                    OR (SA.Stud_Class_Status = 1  
                        AND SA.Stud_Class_Id IN (SELECT Class_Id FROM LMS_Tbl_Emp_Class WHERE Emp_id = @Emp_Id))  

                UNION  

                -- Polls  
                SELECT  
                    DISTINCT P.Poll_id AS Id,  
                    NULL AS Title,  
                    P.Poll_Question AS Description,  
                    P.Poll_Date AS Date,  
                    NULL AS Due_Date,  
                    P.Emp_Id AS Emp_Id,  
                    ''Send'' AS Status,  
                    ''Poll'' AS Type,  
                    CAST(1 AS BIT) AS Stud_Emp_Status,  
                    E.Employee_Fname + '' '' + E.Employee_Lname AS FromName  
                FROM LMS_Tbl_Poll P  
                INNER JOIN LMS_Tbl_Poll_Send PS ON P.Poll_id = PS.Poll_id  
                LEFT JOIN Tbl_Employee E ON E.Employee_Id = P.Emp_Id  
                WHERE  
                    P.Emp_Id = @Emp_Id  
                    OR (PS.Class_Id IN (SELECT Class_Id FROM LMS_Tbl_Emp_Class WHERE Emp_id = @Emp_Id))  

                UNION  

                -- Exams  
                SELECT  
                    DISTINCT E.Exams_Id AS Id,  
                    NULL AS Title,  
                    E.Exam_Name AS Description,  
                    E.Exam_Send_Date AS Date,  
                    E.Exam_Due_Date AS Due_Date,  
                    E.Emp_Id AS Emp_Id,  
                    ''Send'' AS Status,  
                    ''Exam'' AS Type,  
                    CAST(1 AS BIT) AS Stud_Emp_Status,  
                    EMP.Employee_Fname + '' '' + EMP.Employee_Lname AS FromName  
                FROM LMS_Tbl_Exams E  
                INNER JOIN LMS_Tbl_Exam_Send ES ON E.Exams_Id = ES.Exams_Id  
                LEFT JOIN Tbl_Employee EMP ON EMP.Employee_Id = E.Emp_Id  
                WHERE  
                    E.Emp_Id = @Emp_Id  
                    OR (ES.Student_Class_Status = 1  
                        AND ES.Student_Class_Id IN (SELECT Class_Id FROM LMS_Tbl_Emp_Class WHERE Emp_id = @Emp_Id))  

                UNION  

                -- Quizzes  
                SELECT  
                    DISTINCT Q.Quiz_Id AS Id,  
                    NULL AS Title,  
                    Q.Quiz_Name AS Description,  
                    Q.Quiz_Send_Date AS Date,  
                    Q.Quiz_Due_Date AS Due_Date,  
                    Q.Emp_Id AS Emp_Id,  
                    ''Send'' AS Status,  
                    ''Quiz'' AS Type,  
                    CAST(1 AS BIT) AS Stud_Emp_Status,  
                    EMP.Employee_Fname + '' '' + EMP.Employee_Lname AS FromName  
                FROM LMS_Tbl_Quiz Q  
                INNER JOIN LMS_Tbl_Quiz_Send QS ON Q.Quiz_Id = QS.Quiz_Id  
                LEFT JOIN Tbl_Employee EMP ON EMP.Employee_Id = Q.Emp_Id  
                WHERE  
                    Q.Emp_Id = @Emp_Id  
                    OR (QS.Student_Class_Status = 1  
                        AND QS.Student_Class_Id IN (SELECT Class_Id FROM LMS_Tbl_Emp_Class WHERE Emp_id = @Emp_Id))  
            ) AS Post  
            ORDER BY Date DESC;  
        END  
    ')
END
