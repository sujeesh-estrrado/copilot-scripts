IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Employee_Details_Get_By_Employee_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Employee_Details_Get_By_Employee_Id] 
            @Employee_Id BIGINT
        AS
        BEGIN
            SELECT 
                E.Employee_FName + '' '' + E.Employee_LName + '' '' AS [EmpName],  
                E.Employee_Mail, 
                E.Employee_Id, 
                E.*, 
                EO.Department_Id, 
                ED.Dept_Name AS DepartmentName  
            FROM 
                Tbl_Employee E
            INNER JOIN 
                Tbl_Employee_Official EO ON E.Employee_Id = EO.Employee_Id  
            INNER JOIN 
                Tbl_Emp_Department ED ON EO.Department_Id = ED.Dept_Id  
            WHERE 
                E.Employee_Status = 0
                AND E.Employee_Id = @Employee_Id    
        END
    ')
END
