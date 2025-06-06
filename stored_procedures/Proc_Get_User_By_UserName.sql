IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_User_By_UserName]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Get_User_By_UserName](@User_Name VARCHAR(50))
        AS
        BEGIN
            SELECT 
                [user_Id], 
                role_Id, 
                [user_name], 
                user_password, 
                user_Status, 
                user_Email
            FROM 
                Tbl_User
            WHERE 
                [user_name] = @User_Name
        END
    ')
END
