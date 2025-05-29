IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetEmpNameByUserID]') 
    AND type = N'P'
)
BEGIN
    EXEC sp_executesql N'
    CREATE PROCEDURE [dbo].[sp_GetEmpNameByUserID]
    (
        @UserID BIGINT = 0
    )
    AS
    BEGIN
        SELECT CONCAT(E.Employee_FName, '' '', E.Employee_LName) AS Employee_FName 
        FROM Tbl_Employee_User AS EU
        LEFT JOIN Tbl_Employee AS E ON EU.Employee_Id = E.Employee_Id
        WHERE EU.User_Id = @UserID;
    END';
END;
