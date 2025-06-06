IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[PROC_GET_ROLE_DET_BYemployee]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[PROC_GET_ROLE_DET_BYemployee]
        (@employee_id BIGINT)
        AS
        BEGIN
            SELECT * 
            FROM [Tbl_RoleAssignment]
            WHERE employee_id = @employee_id
            AND del_Status = 0
        END
    ')
END
