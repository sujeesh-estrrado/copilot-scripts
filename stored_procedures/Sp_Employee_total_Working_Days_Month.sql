IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Employee_total_Working_Days_Month]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Employee_total_Working_Days_Month] 
            @Emp_Department_Id BIGINT,    
            @FromDate DATETIME,              
            @ToDate DATETIME,
            @TotalDays BIGINT
        AS
        BEGIN
            SELECT 
                DISTINCT EA.Employee_Id,    
                CONCAT(E.Employee_FName, '' '', E.Employee_LName) AS Employee_Name,     
                @TotalDays - (
                    (SELECT COUNT(Emp_Absent_Id) 
                     FROM Tbl_Employee_Absence 
                     WHERE Absent_Date BETWEEN @FromDate AND @ToDate 
                       AND Employee_Id = EA.Employee_Id 
                       AND Absent_Type = ''Both'') +
                    (SELECT CAST(
                        (SELECT COUNT(Emp_Absent_Id) 
                         FROM Tbl_Employee_Absence 
                         WHERE Absent_Date BETWEEN @FromDate AND @ToDate 
                           AND Employee_Id = EA.Employee_Id 
                           AND Absent_Type <> ''Both'') AS FLOAT) 
                     / CAST(2 AS FLOAT))
                ) AS EmpWorkingDays
            FROM Tbl_Employee_Absence EA
            INNER JOIN Tbl_Employee E ON EA.Employee_Id = E.Employee_Id    
            WHERE EA.Emp_Department_Id = @Emp_Department_Id;
        END
    ')
END
