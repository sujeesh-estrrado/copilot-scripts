IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_All_Employee_Grade_Teaching_new_one]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Get_All_Employee_Grade_Teaching_new_one]   
        @Dept_Id bigint,
        @Date varchar(15)          
        AS                        
        BEGIN         
        
        SELECT *                            
        FROM                                
            (                     
                SELECT             
                ROW_NUMBER() OVER                               
                (PARTITION BY Tbl_Employee.Employee_Id ORDER BY Tbl_Employee.Employee_Id) as num, 
                Tbl_Emp_Department.Dept_Name,
                Tbl_Emp_Department.Dept_Id,
                Tbl_Employee.Employee_Id,
                Tbl_Employee.Employee_FName + '' '' + Tbl_Employee.Employee_LName as [Name],
                Tbl_Grade_Mapping.Emp_Grade_Id,
                Tbl_Employee_Grade.Emp_Grade_Name,
                Tbl_Grade_Salary.Total_Salary,
                Tbl_Grade_Salary.Basic_Salary,
                Tbl_Grade_Salary.Salary_Head_ID,
                Tbl_Grade_Salary.Grade_Sal_Value,
                Tbl_Grade_Salary.Mode_Calculation,
                Tbl_Employee_Salary.Gross_Salary,
                Tbl_Employee_Salary.Emp_Id,
                Tbl_Employee_Salary.Date 
                FROM Tbl_Employee 
                INNER JOIN Tbl_Grade_Mapping 
                ON Tbl_Employee.Employee_Id = Tbl_Grade_Mapping.Employee_Id 
                INNER JOIN Tbl_Employee_Grade 
                ON Tbl_Grade_Mapping.Emp_Grade_Id = Tbl_Employee_Grade.Emp_Grade_Id        
                INNER JOIN Tbl_Emp_CourseDepartment_Allocation 
                ON Tbl_Employee.Employee_Id = Tbl_Emp_CourseDepartment_Allocation.Employee_Id         
                INNER JOIN Tbl_Emp_Department 
                ON Tbl_Emp_Department.Dept_Id = Tbl_Emp_CourseDepartment_Allocation.Allocated_CourseDepartment_Id      
                INNER JOIN Tbl_Grade_Salary 
                ON Tbl_Grade_Salary.Grade_Id = Tbl_Employee_Grade.Emp_Grade_Id   
                INNER JOIN Tbl_Employee_Salary 
                ON Tbl_Employee_Salary.Emp_Id = Tbl_Employee.Employee_Id 
                WHERE Tbl_Employee.Employee_Type = ''Teaching'' 
                AND Tbl_Emp_Department.Dept_Id = @Dept_Id 
                AND Tbl_Employee_Salary.Date = @Date 
            ) tbl                              
        WHERE tbl.num = 1                               
        ORDER BY Employee_Id desc          
        END
    ')
END
