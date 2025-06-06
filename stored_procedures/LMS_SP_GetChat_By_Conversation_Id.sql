IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_GetChat_By_Conversation_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LMS_SP_GetChat_By_Conversation_Id] 
            @Conversation_Id BIGINT      
        AS         
        BEGIN
            SET NOCOUNT ON;
            
            -- Fetch sender details
            SELECT 
                Chat.Send_User_Id AS [User_Id],       
                Chat.Send_User_Status AS UserStatus,
                CASE 
                    WHEN Chat.Send_User_Status = 0 THEN Cd.Candidate_Fname + '' '' + Cd.Candidate_Mname + '' '' + Cd.Candidate_Lname                       
                    ELSE E.Employee_Fname + '' '' + E.Employee_Lname  
                END AS FromName          
            FROM dbo.LMS_Tbl_Conversation Con 
            INNER JOIN dbo.LMS_Tbl_Chat Chat ON Con.Conversation_Id = Chat.Conversation_Id   
            LEFT JOIN Tbl_Candidate_Personal_Det Cd ON Cd.Candidate_Id = Chat.Send_User_Id                          
            LEFT JOIN Tbl_Employee E ON E.Employee_Id = Chat.Send_User_Id  
            WHERE Con.Conversation_Id = @Conversation_Id    

            UNION      

            -- Fetch receiver details
            SELECT  
                Rec.Receiver_User_Id AS [User_Id],       
                Rec.Receiver_User_Status AS UserStatus,
                CASE 
                    WHEN Rec.Receiver_User_Status = 0 THEN Cd.Candidate_Fname + '' '' + Cd.Candidate_Mname + '' '' + Cd.Candidate_Lname                       
                    ELSE E.Employee_Fname + '' '' + E.Employee_Lname  
                END AS FromName        
            FROM dbo.LMS_Tbl_Conversation Con 
            INNER JOIN dbo.LMS_Tbl_Chat Chat ON Con.Conversation_Id = Chat.Conversation_Id      
            INNER JOIN dbo.LMS_Tbl_Chat_Receiver Rec ON Chat.Chat_Id = Rec.Chat_Id  
            LEFT JOIN Tbl_Candidate_Personal_Det Cd ON Cd.Candidate_Id = Rec.Receiver_User_Id                          
            LEFT JOIN Tbl_Employee E ON E.Employee_Id = Rec.Receiver_User_Id     
            WHERE Con.Conversation_Id = @Conversation_Id    
        END
    ')
END
