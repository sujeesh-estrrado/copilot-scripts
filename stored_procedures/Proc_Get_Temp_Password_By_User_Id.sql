IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_Temp_Password_By_User_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Get_Temp_Password_By_User_Id]
        (@user_Id INT)
        AS
        BEGIN
            SELECT * 
            FROM tblTemp_Password 
            WHERE user_Id = @user_Id
        END
    ')
END
