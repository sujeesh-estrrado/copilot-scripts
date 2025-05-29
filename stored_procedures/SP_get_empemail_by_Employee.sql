IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_get_empemail_by_Employee]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_get_empemail_by_Employee]   
   @EmployeeIdList VARCHAR(MAX) = NULL  
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Pos INT = 0;
    DECLARE @Item VARCHAR(100);
    DECLARE @UserList TABLE (User_Id BIGINT); 

    IF @EmployeeIdList IS NULL
    BEGIN
        SELECT 0 AS Result;  
        RETURN;
    END

    IF @EmployeeIdList <> ''''
    BEGIN
        WHILE CHARINDEX('','', @EmployeeIdList) > 0
        BEGIN
            SET @Pos = CHARINDEX('','', @EmployeeIdList);
            SET @Item = SUBSTRING(@EmployeeIdList, 1, @Pos - 1);
            INSERT INTO @UserList (User_Id) VALUES (CAST(@Item AS BIGINT));
            SET @EmployeeIdList = SUBSTRING(@EmployeeIdList, @Pos + 1, LEN(@EmployeeIdList));
        END;

        IF LEN(@EmployeeIdList) > 0
            INSERT INTO @UserList (User_Id) VALUES (CAST(@EmployeeIdList AS BIGINT));
    END;

    SELECT 
        e.Employee_Id,  
        CONCAT(e.Employee_Fname, '' '', e.Employee_Lname) AS Employee_Name,
        e.Employee_Mail  
    FROM dbo.tbl_Employee AS e
    INNER JOIN dbo.Tbl_Employee_User AS eu ON e.Employee_Id = eu.Employee_Id
    WHERE 
        eu.User_Id IN (SELECT User_Id FROM @UserList)

    ORDER BY e.Employee_Id;
END;
');
END;
