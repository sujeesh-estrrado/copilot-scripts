-- Check if the stored procedure [dbo].[Proc_getallAgentList] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_getallAgentList]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_getallAgentList]
        (
            @flag BIGINT = 0
        )
        AS 
        BEGIN
            IF (@flag = 0)
            BEGIN
                SELECT 
                    [Agent_ID],
                    CASE 
                        WHEN Agent_Name = '' '' THEN UPPER(Agent_RegNo) 
                        ELSE UPPER(Agent_Name) 
                    END AS Agent_Name
                FROM [dbo].[Tbl_Agent] 
                WHERE Delete_Status = 0
                ORDER BY Agent_Name ASC
            END

            IF (@flag = 1)
            BEGIN
                SELECT 
                    [Agent_ID],
                    CASE 
                        WHEN Agent_Name = '' '' THEN UPPER(Agent_RegNo) 
                        ELSE UPPER(Agent_Name) 
                    END AS Agent_Name
                FROM [dbo].[Tbl_Agent] 
                WHERE Delete_Status = 0 
                    AND Agent_Status = ''Active''  
                ORDER BY Agent_Name ASC
            END
        END
    ')
END
