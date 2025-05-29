IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_AgentDocs_BY_agent_ID]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[SP_GET_AgentDocs_BY_agent_ID]  --1  
    @Agent_Id BIGINT    
AS    
BEGIN    
    SELECT 
        Document_Id,
        Document_Path,
        Agent_Id,
        SUBSTRING(Document_Path, LEN(Document_Path) - CHARINDEX(''\'', REVERSE(Document_Path)) + 2, LEN(Document_Path)) AS Title
    FROM 
        Tbl_Agent_Documents    
    WHERE 
        Agent_Id = @Agent_Id 
        AND Delete_Status = 0   
END
    ')
END
