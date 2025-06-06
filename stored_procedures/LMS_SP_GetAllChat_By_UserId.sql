IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_GetAllChat_By_UserId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LMS_SP_GetAllChat_By_UserId]        
            @User_Id BIGINT,        
            @User_Status BIT        
        AS         
        BEGIN     
            SET NOCOUNT ON;
            
            SELECT  
                Conversation_Id, 
                Time   
            FROM    
            (
                SELECT          
                    c.Conversation_Id,    
                    MAX(ch.[Time]) AS [Time]     
                FROM LMS_Tbl_Conversation c    
                INNER JOIN LMS_Tbl_Chat ch 
                    ON c.Conversation_Id = ch.Conversation_Id      
                INNER JOIN LMS_Tbl_Chat_Receiver cr 
                    ON ch.Chat_Id = cr.Chat_Id      
                WHERE 
                    (ch.Send_User_Id = @User_Id AND ch.Send_User_Status = @User_Status)     
                    OR 
                    (cr.Receiver_User_Id = @User_Id AND cr.Receiver_User_Status = @User_Status)    
                GROUP BY c.Conversation_Id
            ) AS Temp    
            ORDER BY [Time] DESC;                          
        
        END
    ')
END
