IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetAgentDetails_enquiry]')
    AND type = N'P'
)
BEGIN
    EXEC('
    
CREATE PROCEDURE [dbo].[Sp_GetAgentDetails_enquiry]
   @AgentId NVARCHAR(50)
    
AS
BEGIN

    -- Your SQL logic goes here
   --  Agent_ID,
   --         Agent_Email

            --FROM 
   --         Tbl_Agent
   --     WHERE 
   --         Agent_Name =@AgentId 
   SET NOCOUNT ON;  -- Prevents extra result sets from interfering

    -- Check if the agent exists
    IF EXISTS (SELECT 1 FROM Tbl_Agent WHERE Agent_Name = @AgentId)
    BEGIN
        SELECT
            0 AS RETVAL,  -- Indicates success
            Agent_RegNo,
            Agent_Email
            
        FROM 
            Tbl_Agent
        WHERE 
            Agent_Name = @AgentId;
    END
    ELSE
    BEGIN
        SELECT
            100 AS RETVAL,  -- Indicates agent not found
            NULL AS Agent_ID,
            NULL AS Agent_Email;
    END

END
    ')
END
GO