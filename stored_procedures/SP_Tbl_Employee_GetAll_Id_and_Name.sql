IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Employee_GetAll_Id_and_Name]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Employee_GetAll_Id_and_Name]
        AS
        BEGIN
            SELECT Tbl_Employee.Employee_Id,
                   Tbl_Employee.Employee_FName + '' '' + Employee_LName AS [Employee_Name]
            FROM Tbl_Employee
            WHERE Tbl_Employee.Employee_Status = 0
        END
    ')
END
