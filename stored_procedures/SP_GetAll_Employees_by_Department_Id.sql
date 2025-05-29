IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Employees_by_Department_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_Employees_by_Department_Id]              
@Department_Id bigint        
          
AS                  
BEGIN         
      SELECT   Tbl_Employee.Employee_Id, Employee_FName +'' ''+ Employee_LName as Employee_Name,       
    Tbl_Employee_Official.Department_Id ,Tbl_Employee.Employee_DOB as DOB,Tbl_Employee.Employee_Gender as Gender,      
                Tbl_Employee.Employee_Mobile as Mobile,dbo.Tbl_Employee_Official.Employee_DOJ as DOJ ,d.Dept_Name     
           
FROM      Tbl_Employee  INNER JOIN        
                      Tbl_Employee_Official  ON Tbl_Employee.Employee_Id = Tbl_Employee_Official.Employee_Id         
left join dbo.Tbl_Emp_Department d          
on Tbl_Employee_Official.Department_Id=d.Dept_Id    
        
where  Department_Id = @Department_Id   and Tbl_Employee.Employee_Status=0    
          
END

');
END;