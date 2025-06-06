-- Check if the procedure 'Get_Employee_ByEmpIDCode' exists before creating
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_Employee_ByEmpIDCode]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       
CREATE procedure [dbo].[Get_Employee_ByEmpIDCode] 
(@Employee_Id_Card_No varchar(20))
as 
begin 
select E.Employee_FName+'' ''+Employee_LName as EmployeeName,E.Employee_Id,
       E.Employee_Id_Card_No as ECode,
    EO.Department_Id,ED.Dept_Name as DepartmentName
 from Tbl_Employee E
inner join Tbl_Employee_Official EO on E.Employee_Id=EO.Employee_Id
Inner Join Tbl_Emp_Department ED on EO.Department_Id=ED.Dept_Id

where E.Employee_Status=0 and E.Employee_Id_Card_No=@Employee_Id_Card_No

end
    ')
END;
GO
