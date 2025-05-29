IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_getcounsellerlist]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE Procedure [dbo].[sp_getcounsellerlist]  
 AS  
 Begin  
 SELECT distinct e.Employee_Id,concat(e.Employee_FName,'' '',e.Employee_LName) AS [Employee Name],   
 e.Employee_Mail as [Email Id],   
 CONVERT(VARCHAR(10),CAST(eo.Employee_DOJ AS DATETIME), 103) as [Date Of Jojing],   
        eo.Employee_Reporting_Staff as [Reporting to Staff]  
  --eo.Employee_Official_Status,e.Employee_Status,  
  FROM dbo.Tbl_Employee AS e LEFT OUTER JOIN      
        dbo.Tbl_Employee_Official AS eo ON e.Employee_Id = eo.Employee_Id left JOIN      
        --  dbo.Tbl_Employee_Education AS ed ON ed.Employee_Id = e.Employee_Id LEFT OUTER JOIN      
        dbo.Tbl_Emp_Department AS d ON eo.Department_Id = d.Dept_Id      
 WHERE   (e.Employee_Status = 0 )    
 End');
END;

