IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_DELETE_EMPATTENDANCE]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_DELETE_EMPATTENDANCE]    
@Absent_Date  datetime,          
@Departmentid bigint      
    
AS    
BEGIN    
DELETE FROM dbo.Tbl_Employee_Absence
WHERE Absent_Date=@Absent_Date and Emp_Department_Id=@Departmentid    
END
    ')
END
