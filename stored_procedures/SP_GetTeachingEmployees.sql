IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetTeachingEmployees]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    
CREATE PROCEDURE [dbo].[SP_GetTeachingEmployees]
AS
BEGIN
    SELECT DISTINCT 
        CONCAT(E.Employee_FName, '' '', E.Employee_LName) AS empname,
        E.Employee_Mail,
        E.Employee_Id
    FROM 
        Tbl_Employee E
    WHERE 
        E.Employee_Status = 0
        AND E.Employee_Type = ''Teaching'';
END;
    ');
END;
