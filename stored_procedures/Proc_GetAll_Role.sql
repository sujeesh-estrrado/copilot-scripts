-- Check if the stored procedure [dbo].[Proc_GetAll_Role] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAll_Role]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_GetAll_Role]
        AS
        BEGIN
            SELECT  
                role_Id,
                role_Name,
                role_status = CASE 
                    WHEN role_status = 0 THEN ''Inactive'' 
                    ELSE ''Active'' 
                END
            FROM [dbo].[tbl_Role]
            WHERE role_DeleteStatus = 0
            ORDER BY role_Name
        END
    ')
END
