IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Employee_GetByRoleId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Employee_GetByRoleId]
            @deptId BIGINT
        AS
        BEGIN
            SELECT 
                a.Employee_Id, 
                a.Department_Id, 
                b.Employee_FName, 
                b.Employee_LName, 
                c.Department_Name
            FROM 
                dbo.Tbl_Employee_Official a
            LEFT JOIN 
                dbo.Tbl_Employee b ON a.Employee_Id = b.Employee_Id 
            LEFT JOIN 
                dbo.Tbl_Department c ON c.Department_Id = a.Department_Id
            WHERE 
                a.Department_Id = @deptId
        END
    ')
END
