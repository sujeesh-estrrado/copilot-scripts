IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_All_Employee_Gross_Salary_by_Date]') 
    AND type = N'P'
)
BEGIN
    EXEC('
                                   
CREATE procedure [dbo].[SP_Get_All_Employee_Gross_Salary_by_Date]      
                  
       
@Date varchar(15)                    
AS                                  
BEGIN                   
                  
SELECT  Tbl_Emp_Department.Dept_Id ,Tbl_Emp_Department.Dept_Name ,Tbl_Emp_Department.Dept_Id,Tbl_Employee.Employee_Id,Tbl_Employee.Employee_FName+'' ''+Tbl_Employee.Employee_LName as [Name] ,               
Tbl_Employee.Employee_Id_Card_No,Tbl_Employee_Official.Employee_DOJ,Tbl_Employee_Official.Employee_Esi_No,      
      
Tbl_Emp_DeptDesignation.Dept_Designation_Name,Tbl_Employee.Employee_Father_Name,Tbl_Employee.Employee_Nominee_Name      
,Tbl_Employee_Salary.Basic_Salary      
,Tbl_Employee_Salary.Gross_Salary,Tbl_Employee_Salary.Emp_Id,Tbl_Employee_Salary.Date

      
      
FROM Tbl_Employee INNER JOIN                 
                      Tbl_Grade_Mapping ON Tbl_Employee.Employee_Id = Tbl_Grade_Mapping.Employee_Id INNER JOIN                  
                      Tbl_Employee_Grade ON Tbl_Grade_Mapping.Emp_Grade_Id = Tbl_Employee_Grade.Emp_Grade_Id                  
      INNER JOIN                  
                      Tbl_Employee_Official ON Tbl_Employee.Employee_Id = Tbl_Employee_Official.Employee_Id                  
                          inner JOIN                  
                      Tbl_Emp_Department on Tbl_Emp_Department.Dept_Id =Tbl_Employee_Official.Department_Id                    
                                 
                                
   inner join    Tbl_Employee_Salary on    Tbl_Employee_Salary.Emp_Id=Tbl_Employee.Employee_Id        
      

      
inner join   Tbl_Emp_DeptDesignation on  Tbl_Grade_Mapping.Dept_Designation_Id =Tbl_Emp_DeptDesignation.Dept_Designation_Id        
    
where  Tbl_Employee_Salary.Date=@Date                 
ORDER BY Tbl_Employee.Employee_Id desc                    
END

    ')
END
