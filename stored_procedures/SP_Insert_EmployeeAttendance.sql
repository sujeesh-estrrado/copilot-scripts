IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_EmployeeAttendance]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Insert_EmployeeAttendance]      
(      
@Employee_Id bigint,       
@Absent_Date  datetime,      
@Department_Id bigint,  
@AbsentType varchar(150)      
)      
AS      
BEGIN      
      
      
 INSERT INTO      dbo.Tbl_Employee_Absence
             (Employee_Id,Emp_Department_Id,Absent_Date,Absent_Type)        
     VALUES        
           (@Employee_Id,@Department_Id,@Absent_Date      
           ,@AbsentType)        
      
      
END
');
END;
