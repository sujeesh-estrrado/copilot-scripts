IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_get_user_by_Rolename]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[sp_get_user_by_Rolename]
        @role1 VARCHAR(500) = NULL,
        @role2 VARCHAR(500) = NULL
    AS
    BEGIN
        SELECT * 
        FROM tbl_user u
        LEFT JOIN tbl_Role R ON u.role_Id = R.role_Id
        WHERE (@role1 IS NULL OR R.role_Name = @role1)
          AND (@role2 IS NULL OR R.role_Name = @role2)
    END
    ')
END
GO
