IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAll_AdditionalRole]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_GetAll_AdditionalRole]
        AS
        BEGIN
            SELECT  
                role_Id,
                role_Name,
                role_status
            FROM 
                [dbo].[tbl_Role] 
            WHERE 
                role_DeleteStatus = 0 
                AND role_status = 1 
                AND role_Name NOT IN (''Candidate'', ''Employee'', ''Student'') 
            ORDER BY 
                role_Name
        END
    ')
END
