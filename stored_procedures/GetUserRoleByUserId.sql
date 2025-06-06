IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[GetUserRoleByUserId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[GetUserRoleByUserId]
            @UserId INT
        AS
        BEGIN
            SELECT 
                tr.role_id, 
                tr.role_name
            FROM 
                tbl_Role tr
            JOIN 
                Tbl_User tu ON tu.role_id = tr.role_id
            WHERE 
                tu.User_Id = @UserId;
        END
    ')
END
