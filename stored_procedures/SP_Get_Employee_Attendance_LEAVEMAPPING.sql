IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Employee_Attendance_LEAVEMAPPING]') 
    AND type = N'P'
)
BEGIN
    EXEC('
   
CREATE procedure [dbo].[SP_Get_Employee_Attendance_LEAVEMAPPING]-- 2,''2017/10/03''        
@Employee_Id bigint,          
@DateofAttendance varchar(30)          
AS          
BEGIN           
 SELECT  Tbl_Employee.Employee_Id  AS EmployeeID,          
 Tbl_Employee.Employee_FName+'' ''+Employee_LName as Employee_Name,     
   
         
 ISNULL((Select Absent_Type=case Absent_Type   
 when ''Both'' then ''A'' when ''FN'' then ''FN''   
 when ''AN'' then ''AN'' else  ''P'' END From Tbl_Employee  EA  
 RIGHT JOIN Tbl_Employee_Absence E ON E.Employee_Id=EA.Employee_Id  Where               
 Absent_Date=@DateofAttendance and E.Employee_Id=@Employee_Id),''P'') AS IsAbsent,        
        
--ISNUll((SELECT CASE WHEN COUNT(Emp_Leave_Id) > 0 THEN ''LEAVE APPLIED'' ELSE ''---'' END AS [Value]        
--FROM dbo.Tbl_Emp_Leave_Apply where Employee_Id=@Employee_Id        
--and @DateofAttendance  between Emp_Leave_FromDate and Emp_Leave_ToDate),''---'') as LEAVESTATUS  ,       
        
ISNUll((SELECT case when  Emp_Leave_Approve_Status=0 then ''LEAVE APPLIED''              
when  Emp_Leave_Approve_Status=1 then ''APPROVED LEAVE''               
when Emp_Leave_Approve_Status=2 then ''REJECTED LEAVE''              
else ''Pending'' End As [Value]         
FROM dbo.Tbl_Emp_Leave_Apply where Employee_Id=@Employee_Id        
and @DateofAttendance  between Emp_Leave_FromDate and Emp_Leave_ToDate),''---'') as LEAVESTATUS         
         
FROM   Tbl_Employee  where Tbl_Employee.Employee_Id=@Employee_Id  
--and Convert(datetime,Tbl_Employee_Official.Employee_DOJ,103)<=Convert(datetime,@DateofAttendance,103)            
END 
    ');
END;
