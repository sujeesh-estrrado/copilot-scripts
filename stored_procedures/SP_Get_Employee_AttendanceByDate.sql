IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Employee_AttendanceByDate]') 
    AND type = N'P'
)
BEGIN
    EXEC('
  
CREATE procedure [dbo].[SP_Get_Employee_AttendanceByDate]               
@Department_Id bigint,                    
@DateofAttendance varchar(30)                    
AS                    
BEGIN     
select E.Employee_Id,O.Department_Id ,  
  E.Employee_FName+'' ''+E.Employee_LName As [EmployeeName],    
        
  ISNULL((Select IsAbsent=case Absent_Type when ''Both'' then 1 when ''FN'' then 2 when ''AN'' then 3 else  0 END  
  From  dbo.Tbl_Employee_Absence Where Emp_Department_Id=@Department_Id         
  and Absent_Date=@DateofAttendance and Employee_Id=E.Employee_Id),0) AS IsAbsent   
     
  ,ISNULL((Select 1 From Tbl_Employee_Absence Where Emp_Department_Id=@Department_Id        
  and Absent_Date=@DateofAttendance and Employee_Id=E.Employee_Id and Absent_Type=''Both''),0) AS Absent  ,  
        
  ISNULL((Select 1 From Tbl_Employee_Absence Where Emp_Department_Id=@Department_Id        
  and Absent_Date=@DateofAttendance and Employee_Id=E.Employee_Id and Absent_Type=''FN''),0) AS FN  ,     
  ISNULL((Select 1 From Tbl_Employee_Absence Where Emp_Department_Id=@Department_Id        
  and Absent_Date=@DateofAttendance and Employee_Id=E.Employee_Id and Absent_Type=''AN''),0) AS AN    
  
  
  
  
from Tbl_Employee E  
Inner Join Tbl_Employee_Official O on E.Employee_Id=O.Employee_Id  
where O.Department_Id=@Department_Id       and  E.Employee_Status =0
                  
END
    ');
END;
