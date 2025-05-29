IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_HostelFees]') 
    AND type = N'P'
)
BEGIN
    EXEC('
      CREATE PROCEDURE [dbo].[SP_GetAll_HostelFees]                        
                        
      AS                        
                        
      BEGIN     
      SELECT * 
      FROM (      
          SELECT    
              ROW_NUMBER() OVER (PARTITION BY f.Hostel_Fee_Payment_Id ORDER BY f.Hostel_Fee_Payment_Id) AS RNO,                      
              f.Hostel_Fee_Payment_Id,                      
              (CASE 
                  WHEN StudenOrEmployee_Status = 0 THEN ''Student''      
                  ELSE ''Employee'' 
              END) AS [User],                    
              CASE 
                  WHEN StudenOrEmployee_Status = 0 
                  THEN c.Candidate_Fname + '' '' + ISNULL(c.Candidate_Mname, '''') + '' '' + c.Candidate_Lname      
                  ELSE E.Employee_FName + '' '' + E.Employee_LName 
              END AS [UserName],         
              (CASE 
                  WHEN f.StudenOrEmployee_Status = 0 
                  THEN cc.Course_Category_Name + ''-'' + d.Department_Name + ''-'' + cs.Semester_Code       
                  WHEN f.StudenOrEmployee_Status = 1 
                  THEN ED.Dept_Name 
                  ELSE '''' 
              END) AS Department,                
              f.Invoice_Code_id,                   
              i.Invoice_Code_Prefix + f.Invoice_Code + i.Invoice_Code_Suffix AS Invoice_code,                  
              f.Total_Amount,                      
              f.Date,      
              STUFF((SELECT DISTINCT '', '' + CONVERT(CHAR(4), t1.[month], 100) + CONVERT(CHAR(4), t1.[month], 120)       
                     FROM Tbl_Hostel_Fee_Payment_Detail t1      
                     WHERE f.Hostel_Fee_Payment_Id = t1.Hostel_Fee_Payment_Id      
                     FOR XML PATH(''''), TYPE      
                    ).value(''.'', ''NVARCHAR(MAX)'')       
                ,1,2,'''') AS [Month]      
          FROM                        
              Tbl_Hostel_Fee_Payment f        
          INNER JOIN Tbl_Hostel_Fee_Payment_Detail fd ON f.Hostel_Fee_Payment_Id = fd.Hostel_Fee_Payment_Id      
          INNER JOIN Tbl_Inventory_Invoice_Code i ON f.Invoice_Code_id = i.Invoice_Code_Id       
          LEFT JOIN Tbl_Candidate_Personal_Det c ON f.StudentOrEmployee_Id = c.Candidate_Id AND f.StudenOrEmployee_Status = 0                     
          LEFT JOIN Tbl_Course_Duration_Mapping cdm ON f.Department_Id = cdm.Duration_Mapping_Id         
          LEFT JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdp.Duration_Period_Id = cdm.Duration_Period_Id          
          LEFT JOIN Tbl_Course_Department cd ON cd.Course_Department_Id = cdm.Course_Department_Id               
          LEFT JOIN Tbl_Department d ON cd.Department_Id = d.Department_Id               
          LEFT JOIN Tbl_Course_Category cc ON cd.Course_Category_Id = cc.Course_Category_Id        
          LEFT JOIN Tbl_Course_Semester cs ON cs.Semester_Id = cdp.Semester_Id      
          LEFT JOIN Tbl_Employee E ON f.StudentOrEmployee_Id = E.Employee_Id AND f.StudenOrEmployee_Status = 1      
          LEFT JOIN Tbl_Emp_Department ED ON ED.Dept_Id = f.Department_Id      
          WHERE f.Delete_Status = 0
      ) t    
      WHERE t.RNO = 1                          
      END
    ')
END
