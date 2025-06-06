IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Employee_Id_getUserid]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Employee_Id_getUserid] 
            @Employee_Id BIGINT = 0
        AS
        BEGIN
            SELECT 
                Tbl_Employee_Official.Employee_Id,    
                CONCAT(Tbl_Employee.Employee_FName, '' '', Tbl_Employee.Employee_LName) AS Employee,    
                Tbl_Emp_Department.Dept_Name,    
                Tbl_Employee_User.[User_Id]
            FROM Tbl_Employee_Official     
            LEFT JOIN Tbl_Employee ON Tbl_Employee_Official.Employee_Id = Tbl_Employee.Employee_Id    
            LEFT JOIN Tbl_Emp_Department ON Tbl_Employee_Official.Department_Id = Tbl_Emp_Department.Dept_Id     
            LEFT JOIN Tbl_Employee_User ON Tbl_Employee_User.Employee_Id = Tbl_Employee_Official.Employee_Id    
            WHERE Tbl_Employee.Employee_Id = @Employee_Id 
            AND Tbl_Employee.Employee_Status = 0;
        END
    ')
END
