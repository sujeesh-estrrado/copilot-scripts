IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_GetAll_Notes_By_Class_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LMS_SP_GetAll_Notes_By_Class_Id]  
            @Class_Id BIGINT,      
            @Stud_Emp_Id BIGINT,      
            @Emp_Stud_Status BIT      
        AS      
        BEGIN      
            SET NOCOUNT ON;  

            SELECT * FROM (      
                -- Notes
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
                    CASE 
                        WHEN N.Stud_Emp_Status = 0 THEN C.Candidate_Fname + '' '' + C.Candidate_Mname + '' '' + C.Candidate_Lname                  
                        ELSE E.Employee_Fname + '' '' + E.EMployee_Lname  
                    END AS FromName            
                FROM LMS_Tbl_Notes N           
                INNER JOIN LMS_Tbl_Send_Notes SN ON SN.Note_Id = N.Note_Id              
                LEFT JOIN Tbl_Candidate_Personal_Det C ON C.Candidate_Id = N.Stud_Emp_Id                    
                LEFT JOIN Tbl_Employee E ON E.Employee_Id = N.Stud_Emp_Id         
                WHERE SN.Stud_Emp_Class_Id = @Class_Id       
                AND SN.Stud_Emp_Class_Status = 2      
              
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
                    CAST(1 AS BIT) AS Stud_Emp_Status,            
                    E.Employee_Fname + '' '' + E.EMployee_Lname AS FromName                      
                FROM LMS_Tbl_Assignment A          
                INNER JOIN LMS_Tbl_Send_Assignment SA ON A.Assignment_Id = SA.Assignment_Id        
                LEFT JOIN Tbl_Employee E ON E.Employee_Id = A.Emp_Id           
                WHERE SA.Stud_Class_Id = @Class_Id      
        
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
                    CAST(1 AS BIT) AS Stud_Emp_Status,            
                    E.Employee_Fname + '' '' + E.EMployee_Lname AS FromName                              
                FROM LMS_Tbl_Poll P            
                INNER JOIN LMS_Tbl_Poll_Send PS ON P.Poll_id = PS.Poll_id        
                LEFT JOIN Tbl_Employee E ON E.Employee_Id = P.Emp_Id             
                WHERE PS.Class_Id = @Class_Id      
    
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
                    CAST(1 AS BIT) AS Stud_Emp_Status,            
                    EMP.Employee_Fname + '' '' + EMP.EMployee_Lname AS FromName                        
                FROM LMS_Tbl_Exams E                
                INNER JOIN LMS_Tbl_Exam_Send ES ON E.Exams_Id = ES.Exams_Id             
                LEFT JOIN Tbl_Employee EMP ON EMP.Employee_Id = E.Emp_Id             
                WHERE ES.Student_Class_Id = @Class_Id    
      
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
                    CAST(1 AS BIT) AS Stud_Emp_Status,            
                    EMP.Employee_Fname + '' '' + EMP.EMployee_Lname AS FromName                        
                FROM LMS_Tbl_Quiz Q                
                INNER JOIN LMS_Tbl_Quiz_Send ES ON Q.Quiz_Id = ES.Quiz_Id        
                LEFT JOIN Tbl_Employee EMP ON EMP.Employee_Id = Q.Emp_Id             
                WHERE ES.Student_Class_Id = @Class_Id    
            ) AS Post                
            ORDER BY Date DESC;               
        END
    ')
END
