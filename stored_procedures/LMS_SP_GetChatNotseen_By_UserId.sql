IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_GetChatNotseen_By_UserId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LMS_SP_GetChatNotseen_By_UserId]        
            @User_Id BIGINT,        
            @User_Status BIT        
        AS         
        BEGIN     
            SET NOCOUNT ON;
            
            SELECT  
                Conversation_Id,
                [Time],
                Send_User_Id,
                Receiver_User_Id,
                Receiver_User_Status,
                Send_User_Status,
                Chat_Message
            FROM    
            (
                SELECT      
                    c.Conversation_Id,    
                    MAX(ch.[Time]) AS [Time],
                    ch.Send_User_Id,
                    cr.Receiver_User_Id,
                    cr.Receiver_User_Status,
                    ch.Send_User_Status,
                    ch.Chat_Message
                FROM LMS_Tbl_Conversation c    
                INNER JOIN LMS_Tbl_Chat ch ON c.Conversation_Id = ch.Conversation_Id      
                INNER JOIN LMS_Tbl_Chat_Receiver cr ON ch.Chat_Id = cr.Chat_Id      
                WHERE cr.Receiver_User_Id = @User_Id 
                    AND cr.Receiver_User_Status = @User_Status 
                    AND cr.HasSeen = 0    
                GROUP BY c.Conversation_Id, ch.Send_User_Id, ch.Send_User_Status, 
                         cr.Receiver_User_Id, cr.Receiver_User_Status, ch.Chat_Message
            ) AS Temp    
            ORDER BY [Time] DESC;
        END
    ')
END
