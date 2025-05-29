IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_EmployeesBy_Department]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_EmployeesBy_Department]--(@Department_Id bigint)
AS
BEGIN
SELECT 
E.Employee_Id,
E.Employee_FName+'' ''+E.Employee_LName as EmployeeName,
EM.Employee_Department_Id,
D.Department_Name
FROM Tbl_Employee E
INNER JOIN Tbl_Employee_Mapping EM ON E.Employee_Id=EM.Employee_Id
INNER JOIN Tbl_Department D ON D.Department_Id=EM.Employee_Department_Id
WHERE E.Employee_Status=0 --and D.Department_Id=@Department_Id
END

');
END;