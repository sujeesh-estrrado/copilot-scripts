IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_Role]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Get_Role] 
        (@role_Id BIGINT)
        AS
        BEGIN
            SELECT CASE role_Name
                     WHEN ''Lecturer'' THEN ''Employee''
                   END AS role_Name
            FROM dbo.tbl_Role
            WHERE role_id = @role_Id
        END
    ')
END
