IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Employee_By_Dept_Name]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Employee_By_Dept_Name]  
(@Dept varchar(50))    
    
AS    
    
BEGIN    
    
    
SELECT  ROW_NUMBER() over (ORDER BY Tbl_Employee.Employee_Id DESC) AS RowNumber, 
 
Tbl_Employee.Employee_Id as ID,  
  
Tbl_Employee.Employee_FName+'' ''+Tbl_Employee.Employee_LName+'' '' as [Employee Name] ,  
    
Tbl_Employee.Employee_Id_Card_No as [ID No],  
          
Tbl_Employee.Blood_Group as [Blood Group],  
   
Tbl_Emp_Department.Dept_Name as [Department],  
   
Tbl_Employee.Employee_DOB as [DOB],  
  
Tbl_Employee.Employee_Gender as [Gender],  
              
Tbl_Employee.Employee_Mobile as [Mobile],  
  
Tbl_Employee_Official.Employee_DOJ as [DOJ]  
   
FROM         Tbl_Employee_Official INNER JOIN    
                      Tbl_Employee ON Tbl_Employee_Official.Employee_Id = Tbl_Employee.Employee_Id INNER JOIN    
                      Tbl_Emp_Department ON Tbl_Employee_Official.Department_Id = Tbl_Emp_Department.Dept_Id    
where Tbl_Emp_Department.Dept_Name =@Dept and Tbl_Employee.Employee_Status=0    
    
END
');
END;
