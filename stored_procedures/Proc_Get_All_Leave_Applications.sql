IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_All_Leave_Applications]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_Get_All_Leave_Applications]
as begin
SELECT DISTINCT 
                      dbo.Tbl_Employee.Employee_Id as EmployeeID, dbo.Tbl_Employee.Employee_FName+'' ''+dbo.Tbl_Employee.Employee_LName as EmployeeName, dbo.Tbl_Employee_Grade.Emp_Grade_Name as Grade
FROM         dbo.Tbl_Employee INNER JOIN
                      dbo.Tbl_Emp_Leave_Apply ON dbo.Tbl_Employee.Employee_Id = dbo.Tbl_Emp_Leave_Apply.Employee_Id INNER JOIN
                      dbo.Tbl_Grade_Mapping ON dbo.Tbl_Employee.Employee_Id = dbo.Tbl_Grade_Mapping.Employee_Id INNER JOIN
                      dbo.Tbl_Employee_Grade ON dbo.Tbl_Grade_Mapping.Emp_Grade_Id = dbo.Tbl_Employee_Grade.Emp_Grade_Id
WHERE     (dbo.Tbl_Emp_Leave_Apply.Emp_Leave_Delete_Status = 0) AND (dbo.Tbl_Emp_Leave_Apply.Emp_Leave_Approve_Status = 0) AND 
                      (dbo.Tbl_Grade_Mapping.Emp_Grade_Mapping_Status = 0) AND (dbo.Tbl_Employee.Employee_Status = 0) AND (dbo.Tbl_Employee_Grade.Emp_Grade_Status = 0)

--SELECT     dbo.Tbl_Emp_Leave_Apply.Emp_Leave_Id as ID,dbo.Tbl_Emp_Leave_Apply.Employee_Id as [Employee ID],
--                      dbo.Tbl_Emp_Leave_Apply.Emp_Leave_Type as [LeaveType ID], 
--                      dbo.Tbl_Emp_Leave_Apply.Emp_LeaveDate as LeaveDate,
--                    dbo.Tbl_Emp_Leave_Apply.Emp_Leave_Reason, 
--                      dbo.Tbl_Emp_Leave_Apply.Emp_Leave_Approve_Status as [Approve Status],
--                    dbo.Tbl_Leave_Type.Leave_Type_Name as [LeaveType Name], dbo.Tbl_Leave_Type.Leave_Color as TypeColor, 
--                      dbo.Tbl_Employee.Employee_FName+'''' ''''+dbo.Tbl_Employee.Employee_LName as FullName
--FROM         dbo.Tbl_Emp_Leave_Apply
--
-- INNER JOIN dbo.Tbl_Leave_Type ON dbo.Tbl_Emp_Leave_Apply.Emp_Leave_Type = dbo.Tbl_Leave_Type.Leave_Type_Id 
-- INNER JOIN dbo.Tbl_Employee ON dbo.Tbl_Emp_Leave_Apply.Employee_Id = dbo.Tbl_Employee.Employee_Id
--
--where dbo.Tbl_Emp_Leave_Apply.Emp_Leave_Approve_Status=0 and dbo.Tbl_Emp_Leave_Apply.Emp_Leave_Delete_Status=0
end
    ')
END
