IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_AbsentEmployee]')
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[SP_GetAll_AbsentEmployee] 
(@AbsentDate datetime
)     
      
as      
      
begin      
      
SELECT e.*,eo.*,d.Dept_Name,e.Employee_FName+'' ''+e.Employee_LName+'' '' as [Employee Name]      
FROM [Tbl_Employee] e right join dbo.Tbl_Employee_Official eo on e.Employee_Id=eo.Employee_Id 
left join dbo.Tbl_Emp_Department d on eo.Department_Id=d.Dept_Id where e.Employee_Status=0
and e.Employee_Id in(select Employee_Id from dbo.Tbl_Employee_Absence where  Absent_Date=@AbsentDate)
order by [Employee Name]   
      
end

    ')
END
GO
