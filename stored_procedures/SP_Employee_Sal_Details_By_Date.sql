IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Employee_Sal_Details_By_Date]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Employee_Sal_Details_By_Date]
            @Date VARCHAR(15),
            @Emp_Id BIGINT
        AS
        BEGIN
            SELECT 
                Tbl_Employee_Salary.*, 
                Tbl_Employee_Salary_Details.*
            FROM 
                Tbl_Employee_Salary 
            INNER JOIN 
                Tbl_Employee_Salary_Details 
                ON Tbl_Employee_Salary.Employee_Salary_Id = Tbl_Employee_Salary_Details.Employee_Salary_Id
            WHERE 
                Date = @Date 
                AND Emp_Id = @Emp_Id
        END
    ')
END
