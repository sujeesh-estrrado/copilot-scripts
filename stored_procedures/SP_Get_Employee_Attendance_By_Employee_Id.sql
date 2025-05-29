IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Employee_Attendance_By_Employee_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[SP_Get_Employee_Attendance_By_Employee_Id]  -- 2,''2016-08-01 00:00:00.000''     
@Employee_Id bigint,      
@DateofAttendance varchar(30)      
AS      
BEGIN       
 SELECT Employee_Id  AS EmployeeID,      
 Employee_FName+'' ''+Employee_LName as Employee_Name      
 ,       
 ISNULL((Select Absent_Type=case Absent_Type when ''Both'' then ''A'' when ''FN'' then ''FN'' when ''AN'' then ''AN'' else  
 ''P'' END From Tbl_Employee_Absence Where           
 Absent_Date=@DateofAttendance and Employee_Id=Tbl_Employee.Employee_Id),''P'') AS IsAbsent      
--case EA.Absent_Type when ''Both'' then ''A''
-- when ''FN'' then ''FN'' 
-- when ''AN'' then ''AN'' 
-- else  ''P'' END as  Absent_Type 

FROM         Tbl_Employee
--inner join dbo.Tbl_Employee_Absence EA ON EA.Employee_Id=E.Employee_Id

where Employee_Id=@Employee_Id      
END

    ');
END;
