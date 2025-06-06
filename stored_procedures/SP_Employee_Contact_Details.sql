IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Employee_Contact_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Employee_Contact_Details] 
            @Employee_Id BIGINT
        AS
        BEGIN
            SELECT 
                Employee_Id,
                CONCAT(Employee_FName, '' '', Employee_LName) AS [Employee Name],
                Employee_Mail,
                Employee_Phone,
                Employee_Permanent_Address,
                Employee_Present_Address
            FROM Tbl_Employee 
            WHERE Employee_Id = @Employee_Id 
            AND Employee_Status = 0;
        END
    ')
END
