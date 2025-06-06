IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployeeNameByUserId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[GetEmployeeNameByUserId]
            @UserId BIGINT
        AS
        BEGIN
            SELECT 
                e.Employee_FName, 
                e.Employee_LName
            FROM [Elvis_SevenSkies_DEV].[dbo].[Tbl_Employee_User] eu
            INNER JOIN [Elvis_SevenSkies_DEV].[dbo].[Tbl_Employee] e
                ON eu.Employee_Id = e.Employee_Id
            WHERE eu.User_Id = @UserId;
        END
    ')
END
