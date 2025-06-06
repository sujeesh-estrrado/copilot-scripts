IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_GetChat_By_UserId_and_ReceiverId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LMS_SP_GetChat_By_UserId_and_ReceiverId]        
            @Conversation_Id BIGINT      
        AS         
        BEGIN
            SET NOCOUNT ON;
            
            SELECT DISTINCT    
                Co.Conversation_Id,      
                C.Chat_Id,        
                C.Chat_Message,        
                C.[Time],        
                C.Send_User_Id,        
                C.Send_User_Status,        
                CR.Receiver_User_Id,        
                CR.Receiver_User_Status, 
                ISNULL(Co.Group_id, 0) AS Group_Id,
                
                -- Sender Name
                CASE 
                    WHEN C.Send_User_Status = 0 
                    THEN Cd.Candidate_Fname + '' '' + Cd.Candidate_Mname + '' '' + Cd.Candidate_Lname                     
                    ELSE E.Employee_Fname + '' '' + E.Employee_Lname  
                END AS FromName,        

                -- Receiver Name
                CASE 
                    WHEN CR.Receiver_User_Status = 0 
                    THEN Cd1.Candidate_Fname + '' '' + Cd1.Candidate_Mname + '' '' + Cd1.Candidate_Lname                     
                    ELSE E1.Employee_Fname + '' '' + E1.Employee_Lname  
                END AS ToName        

            FROM LMS_Tbl_Conversation Co      
            INNER JOIN LMS_Tbl_Chat C ON Co.Conversation_Id = C.Conversation_Id      
            INNER JOIN LMS_Tbl_Chat_Receiver CR ON C.Chat_Id = CR.Chat_Id        
            LEFT JOIN Tbl_Candidate_Personal_Det Cd ON Cd.Candidate_Id = C.Send_User_Id                        
            LEFT JOIN Tbl_Employee E ON E.Employee_Id = C.Send_User_Id         
            LEFT JOIN Tbl_Candidate_Personal_Det Cd1 ON Cd1.Candidate_Id = CR.Receiver_User_Id                        
            LEFT JOIN Tbl_Employee E1 ON E1.Employee_Id = CR.Receiver_User_Id         
            WHERE Co.Conversation_Id = @Conversation_Id       
        END
    ')
END
