IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_All_Employee_Department_Teaching]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Get_All_Employee_Department_Teaching]    
        AS              
        BEGIN 

        SELECT *                    
        FROM                        
            (             
                SELECT     
                ROW_NUMBER() OVER                       
                (PARTITION BY Tbl_Emp_Department.Dept_Id ORDER BY Tbl_Emp_Department.Dept_Id) as num,
                Tbl_Emp_Department.Dept_Id, 
                Tbl_Emp_Department.Dept_Name as Department,
                Tbl_Employee.Employee_Id,
                Tbl_Employee.Employee_FName + '' '' + Tbl_Employee.Employee_LName as [Name]
                FROM Tbl_Employee 
                INNER JOIN Tbl_Emp_CourseDepartment_Allocation 
                ON Tbl_Employee.Employee_Id = Tbl_Emp_CourseDepartment_Allocation.Employee_Id 
                INNER JOIN Tbl_Emp_Department 
                ON Tbl_Emp_Department.Dept_Id = Tbl_Emp_CourseDepartment_Allocation.Allocated_CourseDepartment_Id
                WHERE Tbl_Employee.Employee_Type = ''Teaching''
            ) tbl                       
        WHERE tbl.num = 1                       
        ORDER BY Dept_Id desc  

        END
    ')
END
