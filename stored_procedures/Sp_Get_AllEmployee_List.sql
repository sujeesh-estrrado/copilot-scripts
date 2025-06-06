IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_AllEmployee_List]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[Sp_Get_AllEmployee_List]
AS
BEGIN
    select e.Employee_FName+'' ''+e.Employee_LName as EmployeeName,e.Employee_Id,eo.Department_Id  from 
     Tbl_Employee_Official eo INNER JOIN    
     Tbl_Employee e ON eo.Employee_Id = e.Employee_Id INNER JOIN    
     Tbl_Emp_Department ON eo.Department_Id = Tbl_Emp_Department.Dept_Id    
     where e.Employee_Status=0 
END


    ')
END
