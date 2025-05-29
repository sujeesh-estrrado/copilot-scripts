IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Employee_Leave_By_Date]') 
    AND type = N'P'
)
BEGIN
    EXEC('
 CREATE procedure [dbo].[SP_Get_Employee_Leave_By_Date]     
   
@DateofAttendance varchar(30)    
AS    
BEGIN     
 SELECT  Tbl_Employee.Employee_Id  AS EmployeeID,    
 Tbl_Employee.Employee_FName+'' ''+Employee_LName as Employee_Name    
 ,     
 ISNULL((Select Absent_Type=case Absent_Type when ''Both'' then ''A'' when ''FN'' then ''FN'' when ''AN'' then ''AN'' else  ''P'' END From Tbl_Employee_Absence Where         
 Absent_Date=@DateofAttendance and Employee_Id=Tbl_Employee.Employee_Id),''P'') AS IsAbsent    
FROM         Tbl_Employee     
END

    ');
END;
