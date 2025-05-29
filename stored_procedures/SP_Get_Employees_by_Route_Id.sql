IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Employees_by_Route_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Employees_by_Route_Id]
(@Dept_Id bigint,
@RouteFeeId  bigint         
)  
  
AS  
  
BEGIN  
  
  
SELECT    
 Tbl_Employee_Official.Employee_Id,
Tbl_Employee.Employee_FName +'' ''+Tbl_Employee.Employee_LName as Employee ,
 Tbl_Emp_Department.Dept_Name,
ISNULL(Employee_Route_Mapping_Id,0) As Employee_Route_Mapping_Id,
ISNULL((Select Employee_Route_Mapping_Id From Tbl_Employee_Route_Mapping where RouteFeeId<>@RouteFeeId and  EmployeeId= Tbl_Employee.Employee_Id),0)  As OtherRouteId
FROM         Tbl_Employee_Official INNER JOIN  
                      Tbl_Employee ON Tbl_Employee_Official.Employee_Id = Tbl_Employee.Employee_Id INNER JOIN  
                      Tbl_Emp_Department ON Tbl_Employee_Official.Department_Id = Tbl_Emp_Department.Dept_Id  
LEFT JOIN Tbl_Employee_Route_Mapping ER ON ER.EmployeeId=Tbl_Employee.Employee_Id and ER.RouteFeeId=@RouteFeeId
where Tbl_Emp_Department.Dept_Id =@Dept_Id and Tbl_Employee.Employee_Status=0  
  
END

	');
END;
