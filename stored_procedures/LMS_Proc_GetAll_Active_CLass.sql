IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_Proc_GetAll_Active_CLass]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_Proc_GetAll_Active_CLass]  
  
AS  
  
BEGIN  
  
SELECT  
 EC.Emp_Class_Id,  
 C.Class_Id,  
 C.Active_Status,  
 EC.Emp_Id,  
 C.Class_Name,  
 E.Employee_FName+''''+Employee_LName as [Employee]  
  
         
FROM    dbo.LMS_Tbl_Emp_Class EC   
 INNER JOIN dbo.LMS_Tbl_Class C on C.Class_Id=EC.Class_Id  
 INNER JOIN dbo.Tbl_Employee E on E.Employee_Id=EC.Emp_Id  
where C.Active_Status = 1
    
END
    ')
END
