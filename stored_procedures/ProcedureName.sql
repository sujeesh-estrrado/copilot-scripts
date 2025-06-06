IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[ProcedureName]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[ProcedureName]
        (
            @AgentId NVARCHAR(50)
        )
        AS
        BEGIN
            SELECT
                Agent_ID,
                Agent_Email
            FROM 
                Tbl_Agent
            WHERE 
                Agent_Name = @AgentId;
        END
    ')
END
