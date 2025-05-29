IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAllLeave_Employees]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[SP_GetAllLeave_Employees]         
        @From_Date DATETIME,         
        @To_Date DATETIME              
    AS              
    BEGIN              
        SELECT 
            Tbl_Emp_Leave_Apply.Emp_Leave_Id AS ID,
            Tbl_Emp_Leave_Apply.Employee_Id AS [Employee ID],    
            Tbl_Employee.Employee_FName + '' '' + Tbl_Employee.Employee_LName AS EmployeeName,    
            D.Department_Name,    
            Tbl_Emp_Leave_Apply.Emp_Leave_Type AS [LeaveType ID],                 
            Tbl_Emp_Leave_Apply.Emp_Leave_FromDate AS LeaveFromDate,                
            Tbl_Emp_Leave_Apply.Emp_Leave_ToDate AS LeaveToDate,                
            Tbl_Emp_Leave_Apply.Emp_Leave_Reason,                 
            Tbl_Emp_Leave_Apply.Emp_Leave_Approve_Status AS [Approve Status],                
            Tbl_Leave_Type.Leave_Type_Name AS [LeaveType Name],    
            Tbl_Leave_Type.Leave_Color AS TypeColor,                 
            Tbl_Employee.Employee_FName + '' '' + Tbl_Employee.Employee_LName AS FullName,            
            CASE 
                WHEN Emp_Leave_Approve_Status = 0 THEN ''Pending''            
                WHEN Emp_Leave_Approve_Status = 1 THEN ''Approved''             
                WHEN Emp_Leave_Approve_Status = 2 THEN ''Rejected''            
                ELSE ''Pending'' 
            END AS ApprovalStatus,          
            CASE 
                WHEN Emp_Leave_IsHalfDay = 1 THEN ''Half Day'' 
                ELSE ''Full Day'' 
            END AS IsHalfDay          
        FROM dbo.Tbl_Emp_Leave_Apply                
        INNER JOIN dbo.Tbl_Leave_Type ON dbo.Tbl_Emp_Leave_Apply.Emp_Leave_Type = dbo.Tbl_Leave_Type.Leave_Type_Id                 
        INNER JOIN dbo.Tbl_Employee ON dbo.Tbl_Emp_Leave_Apply.Employee_Id = dbo.Tbl_Employee.Employee_Id      
        INNER JOIN dbo.Tbl_Employee_Official EO ON EO.Employee_Id = dbo.Tbl_Employee.Employee_Id      
        INNER JOIN dbo.Tbl_Department D ON D.Department_Id = EO.Department_Id                
        WHERE 
            dbo.Tbl_Emp_Leave_Apply.Emp_Leave_Delete_Status = 0  
            AND Tbl_Emp_Leave_Apply.Emp_Leave_Approve_Status = 1    
            AND dbo.Tbl_Employee.Employee_Status = 0  
            AND (
                Tbl_Emp_Leave_Apply.Emp_Leave_FromDate BETWEEN @From_Date AND @To_Date 
                OR Tbl_Emp_Leave_Apply.Emp_Leave_ToDate BETWEEN @From_Date AND @To_Date
                OR @From_Date BETWEEN Tbl_Emp_Leave_Apply.Emp_Leave_FromDate AND Tbl_Emp_Leave_Apply.Emp_Leave_ToDate
            )         
    END')
END;
