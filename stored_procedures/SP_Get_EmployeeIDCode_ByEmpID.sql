IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_EmployeeIDCode_ByEmpID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_EmployeeIDCode_ByEmpID]  
(@Employee_Id bigint)  
AS   
BEGIN   
SELECT E.Employee_FName+'' ''+Employee_LName as EmployeeName,  
       E.Employee_Id_Card_No as ECode,  
       EO.Department_Id,ED.Dept_Name as DepartmentName  
FROM Tbl_Employee E  
inner join Tbl_Employee_Official EO on E.Employee_Id=EO.Employee_Id  
Inner Join Tbl_Emp_Department ED on EO.Department_Id=ED.Dept_Id  
  
WHERE E.Employee_Status=0 and E.Employee_Id=@Employee_Id 
  
END

	');
END;
