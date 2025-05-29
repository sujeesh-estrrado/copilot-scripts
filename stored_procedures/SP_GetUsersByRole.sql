IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetUsersByRole]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_GetUsersByRole]
as
begin
SELECT E.Employee_Id,CONCAT(Employee_FName,'' '',Employee_LName) AS FullName

FROM Tbl_Employee E
JOIN Tbl_Employee_User EU ON E.Employee_Id = EU.Employee_Id
LEFT JOIN Tbl_User U ON U.User_Id = EU.User_Id
JOIN Tbl_Role R ON R.Role_Id = U.Role_Id
WHERE R.role_Name IN (''Counsellor'', ''Counsellor Lead'')
end
    ')
END;
