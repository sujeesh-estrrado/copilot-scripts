IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_GetAll_NotificationsDetails_By_Stud_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LMS_SP_GetAll_NotificationsDetails_By_Stud_Id]
        @Student_Id bigint                    
        AS                    
        BEGIN          
            SET NOCOUNT ON;
            
            SELECT DISTINCT        
                [Type], STN.Date,        
                Stud_Notofication_id,      
                STN.Type_Id,      
                (CASE WHEN N.Note_Description IS NULL THEN ''No Data'' ELSE N.Note_Description END) AS Note_Description,        
                (CASE WHEN SN.Approval_Status IS NULL THEN ''False'' ELSE SN.Approval_Status END) AS Approval_Status,        
                (CASE WHEN N.Note_Id IS NULL THEN 0 ELSE N.Note_Id END) AS Note_Id,       
                (CASE WHEN N.Stud_Emp_Id IS NULL THEN 0 ELSE N.Stud_Emp_Id END) AS Stud_Emp_Id,      
                (CASE WHEN N.Stud_Emp_Status IS NULL THEN ''False'' ELSE N.Stud_Emp_Status END) AS Stud_Emp_Status,       
                CASE 
                    WHEN N.Stud_Emp_Status = 0 THEN CM.Candidate_Fname + '' '' + CM.Candidate_Mname + '' '' + CM.Candidate_Lname        
                    WHEN N.Stud_Emp_Status = 1 THEN EM.Employee_FName + '' '' + EM.Employee_LName 
                END AS FromName,        
                (CASE WHEN A.Assignment_Id IS NULL THEN 0 ELSE A.Assignment_Id END) AS Assignment_Id,        
                (CASE WHEN A.Assignment_Title IS NULL THEN ''No Data'' ELSE A.Assignment_Title END) AS Assignment_Title,        
                (CASE WHEN A.Due_Date IS NULL THEN ''01/01/01 12:12:12'' ELSE A.Due_Date END) AS Due_Date,        
                (CASE WHEN Q.Quiz_Id IS NULL THEN 0 ELSE Q.Quiz_Id END) AS Quiz_Id,        
                (CASE WHEN Q.Quiz_Name IS NULL THEN ''No Data'' ELSE Q.Quiz_Name END) AS Quiz_Name,        
                (CASE WHEN Q.Quiz_Date IS NULL THEN ''01/01/01 12:12:12'' ELSE Q.Quiz_Date END) AS Quiz_Date,        
                (CASE WHEN E.Exams_Id IS NULL THEN 0 ELSE E.Exams_Id END) AS Exams_Id,        
                (CASE WHEN E.Exam_Name IS NULL THEN ''No Data'' ELSE E.Exam_Name END) AS Exam_Name,        
                (CASE WHEN E.Exam_Date IS NULL THEN ''01/01/01 12:12:12'' ELSE E.Exam_Date END) AS Exam_Date,      
                (CASE WHEN P.Poll_id IS NULL THEN 0 ELSE P.Poll_id END) AS Poll_id,          
                (CASE WHEN P.Poll_Question IS NULL THEN ''No data'' ELSE P.Poll_Question END) AS Poll_Question,       
                (CASE WHEN P.Poll_Date IS NULL THEN ''01/01/01 12:12:12'' ELSE P.Poll_Date END) AS Poll_Date,  
                (CASE WHEN OM.Meeting_Name IS NULL THEN ''No data'' ELSE OM.Meeting_Name END) AS Meeting_Name,       
                (CASE WHEN OM.Meeting_Code IS NULL THEN ''No data'' ELSE OM.Meeting_Code END) AS Meeting_Code,   
                (CASE WHEN OM.Meeting_Time IS NULL THEN ''01/01/01 12:12:12'' ELSE OM.Meeting_Time END) AS Meeting_Time,  
                (CASE WHEN OM.Date IS NULL THEN ''01/01/01 12:12:12'' ELSE OM.Date END) AS Date,  
                View_Status,        
                STN.Student_Id,      
                CM.Candidate_Fname + '' '' + CM.Candidate_Mname + '' '' + CM.Candidate_Lname AS Name_      
            FROM dbo.LMS_Tbl_Student_Notification STN          
            LEFT JOIN LMS_Tbl_Notes N ON N.Note_Id = STN.Type_Id        
            LEFT JOIN LMS_Tbl_Send_Notes SN ON SN.Note_Id = N.Note_Id AND SN.Approval_Status = 0         
            LEFT JOIN LMS_Tbl_Assignment A ON A.Assignment_Id = STN.Type_Id        
            LEFT JOIN LMS_Tbl_Send_Assignment SA ON SA.Assignment_Id = A.Assignment_Id        
            LEFT JOIN LMS_Tbl_Exams E ON E.Exams_Id = STN.Type_Id       
            LEFT JOIN Tbl_Employee EM ON EM.Employee_Id = N.Stud_Emp_Id      
            LEFT JOIN LMS_Tbl_Exam_Send ES ON ES.Exams_Id = E.Exams_Id        
            LEFT JOIN LMS_Tbl_Poll P ON P.Poll_id = STN.Type_Id      
            LEFT JOIN LMS_Tbl_Poll_Send PS ON PS.Poll_id = P.Poll_id        
            LEFT JOIN LMS_Tbl_Quiz Q ON Q.Quiz_Id = STN.Type_Id        
            LEFT JOIN LMS_Tbl_Quiz_Send QS ON QS.Quiz_Id = Q.Quiz_Id      
            LEFT JOIN LMS_Tbl_Online_Meeting OM ON OM.Meeting_Id = STN.Type_Id    
            LEFT JOIN Tbl_Candidate_Personal_Det CM ON CM.Candidate_Id = STN.Student_Id      
            WHERE STN.Student_Id = @Student_Id         
            GROUP BY 
                STN.Date, View_Status, SN.Approval_Status, Stud_Notofication_id, N.Note_Description,        
                STN.Student_Id, N.Note_Id, A.Assignment_Id, A.Assignment_Title, N.Stud_Emp_Status,        
                A.Due_Date, Q.Quiz_Id, Q.Quiz_Name, Q.Quiz_Date,        
                E.Exams_Id, E.Exam_Name, E.Exam_Date,        
                P.Poll_id, P.Poll_Question, P.Poll_Date,      
                STN.Type_Id, N.Stud_Emp_Status,      
                CM.Candidate_Fname + '' '' + CM.Candidate_Mname + '' '' + CM.Candidate_Lname,       
                N.Stud_Emp_Id, EM.Employee_FName + '' '' + EM.Employee_LName,   
                OM.Meeting_Name, OM.Meeting_Code, OM.Meeting_Time, OM.Date,     
                [Type]        
            ORDER BY STN.Date DESC;
        END
    ')
END
