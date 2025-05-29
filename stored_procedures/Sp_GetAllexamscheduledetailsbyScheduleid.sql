IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetAllexamscheduledetailsbyScheduleid]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_GetAllexamscheduledetailsbyScheduleid]    
        (    
            @schedule BIGINT = 0,    
            @flag BIGINT = 0    
        )                      
        AS                      
        BEGIN                      
            IF (@flag = 0)    
            BEGIN    
                SELECT DISTINCT  
                    Exam_Schedule_Details_Id,
                    (SELECT TOP 1 Exam_Schedule_Id FROM Tbl_Exam_Schedule WHERE Exam_Schedule_Id = E.Exam_Schedule_Id) AS Exam_Schedule_Id, 
                    R.Room_Name AS venue,
                    (SELECT TOP 1 Course_id FROM Tbl_Exam_Schedule WHERE Exam_Schedule_Id = E.Exam_Schedule_Id) AS Course_id,                
                    CONCAT(I.Employee_FName, '' '', I.Employee_LName) AS ChiefInvigilator,
                    Total_student_requested,            
                    CASE 
                        WHEN RB.ApprovalStatus = 1 THEN ''Approved''            
                        WHEN RB.ApprovalStatus = 2 THEN ''Reject''            
                        WHEN RB.ApprovalStatus = 0 THEN ''Approval Pending'' 
                    END AS Status            
                FROM 
                    Tbl_Exam_Schedule_Details E 
                INNER JOIN Tbl_Room R ON R.Room_Id = E.Venue             
                INNER JOIN Tbl_Employee I ON I.Employee_Id = E.ChiefInvigilator                
                LEFT JOIN tbl_RoomBooking RB ON RB.Room = R.Room_Id AND RB.RefID = E.Exam_Schedule_Details_Id         
                WHERE 
                    E.Exam_Schedule_Id = @schedule 
                    AND Exam_Schedule_Details_Status = 0   
                    AND (RB.ApprovalStatus = 1 OR RB.ApprovalStatus = 0)           
            END    
                  
            IF (@flag = 1)    
            BEGIN    
                SELECT DISTINCT  
                    Exam_Schedule_Details_Id,
                    (SELECT TOP 1 Exam_Schedule_Id FROM Tbl_Exam_Schedule WHERE Exam_Schedule_Id = E.Exam_Schedule_Id) AS Exam_Schedule_Id,
                    '''' AS venue,
                    '''' AS Status,
                    (SELECT TOP 1 Course_id FROM Tbl_Exam_Schedule WHERE Exam_Schedule_Id = E.Exam_Schedule_Id) AS Course_id,                
                    CONCAT(I.Employee_FName, '' '', I.Employee_LName) AS ChiefInvigilator,
                    Total_student_requested     
                FROM 
                    Tbl_Exam_Schedule_Details E     
                INNER JOIN Tbl_Employee I ON I.Employee_Id = E.ChiefInvigilator        
                WHERE 
                    E.Exam_Schedule_Id = @schedule 
                    AND Exam_Schedule_Details_Status = 0    
            END    
        END  
    ')
END
