IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Employee_AttendancePercentage_By_DeptId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
  
CREATE procedure [dbo].[Sp_Get_Employee_AttendancePercentage_By_DeptId]      
@Emp_Department_Id bigint,      
@FromDate Datetime,                
@ToDate Datetime      
As      
BEGIN          
Declare @TotalDays float      
Set @TotalDays=(Select(DATEDIFF(DD,@FromDate,@ToDate)+1))      
      
Select       
Distinct EA.Employee_Id,      
Employee_FName+'' ''+Employee_LName as Employee_Name,       
@TotalDays-(      
(Select Count(Emp_Absent_Id) From Tbl_Employee_Absence Where Absent_Date between @FromDate and @ToDate and Employee_Id=EA.Employee_Id and Absent_Type=''Both'' )+      
(SELECT Cast((Select Count(Emp_Absent_Id) From Tbl_Employee_Absence Where Absent_Date between @FromDate and @ToDate and Employee_Id=EA.Employee_Id and Absent_Type<>''Both'')As Float)/ CAST(2 AS float)))      
As EmpWorkingDays,      
 ROUND(((@TotalDays-(      
(Select Count(Emp_Absent_Id) From Tbl_Employee_Absence Where Absent_Date between @FromDate and @ToDate and Employee_Id=EA.Employee_Id and Absent_Type=''Both'' )+      
(SELECT Cast((Select Count(Emp_Absent_Id) From Tbl_Employee_Absence Where Absent_Date between @FromDate and @ToDate and Employee_Id=EA.Employee_Id and Absent_Type<>''Both'')As Float)/ CAST(2 AS float))))/@TotalDays)*100,2) As AttendPerc      
From       
Tbl_Employee_Absence EA      
INNER JOIN Tbl_Employee E ON EA.Employee_Id=E.Employee_Id      
  
inner join  dbo.Tbl_Employee_Official eo on eo.Employee_Id=E.Employee_Id       
Where eo.Employee_DOJ<=@FromDate and  Emp_Department_Id=@Emp_Department_Id     
  
END    
    ');
END;
