-- Check if the stored procedure [dbo].[Proc_GetAllAgentForCReg] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAllAgentForCReg]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_GetAllAgentForCReg]
        AS
        BEGIN
            SELECT 
                [Agent_ID],
                [Agent_Name],
                [Agent_Status] 
            FROM [dbo].[Tbl_Agent] 
            WHERE [Agent_Status] = 0
        END
    ')
END
