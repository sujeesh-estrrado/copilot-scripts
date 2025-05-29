IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_EmployeeDetails_by_Department_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_EmployeeDetails_by_Department_Id] --3
 (@Dept_Id bigint)  
  
AS  
  
BEGIN  
  
  
SELECT        Tbl_Employee_Official.Employee_Id,
              concat(Tbl_Employee.Employee_FName,'' '',Tbl_Employee.Employee_LName) as Employee ,
              Tbl_Emp_Department.Dept_Name ,
              Tbl_Employee_User.[User_Id]
			  FROM Tbl_Employee_Official 
              left JOIN  Tbl_Employee ON Tbl_Employee_Official.Employee_Id = Tbl_Employee.Employee_Id
              left JOIN Tbl_Emp_Department ON Tbl_Employee_Official.Department_Id = Tbl_Emp_Department.Dept_Id 
              left JOIN Tbl_Employee_User ON Tbl_Employee_User.Employee_Id = Tbl_Employee_Official.Employee_Id
              where Tbl_Emp_Department.Dept_Id =@Dept_Id and Tbl_Employee.Employee_Status=0  
  
END

	');
END;
