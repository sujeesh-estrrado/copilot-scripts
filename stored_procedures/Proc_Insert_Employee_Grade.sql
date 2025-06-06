-- Check if the stored procedure [dbo].[Proc_Insert_Employee_Grade] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert_Employee_Grade]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_Insert_Employee_Grade]   
 (@emp_Grade_Name varchar(100))  
AS  
  
IF EXISTS(SELECT Emp_Grade_Name FROM Tbl_Employee_Grade Where Emp_Grade_Name = LTRIM(RTRIM( @emp_Grade_Name)) and Emp_Grade_Status=0 )  
BEGIN  
RAISERROR (''Data already Exists.'', -- Message text.  
               16, -- Severity.  
               1 -- State.  
               );  
END  
ELSE  
   
BEGIN   
   
  insert into Tbl_Employee_Grade(Emp_Grade_Name)  
  values(@emp_Grade_Name)  
  
   
END
    ')
END
