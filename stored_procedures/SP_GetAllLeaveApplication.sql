IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAllLeaveApplication]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[SP_GetAllLeaveApplication]         
    AS        
    BEGIN        
        SELECT 
            dbo.Tbl_Emp_Leave_Apply.Emp_Leave_Id AS ID,
            dbo.Tbl_Emp_Leave_Apply.Employee_Id AS [Employee ID],          
            dbo.Tbl_Emp_Leave_Apply.Emp_Leave_Type AS [LeaveType ID],           
            dbo.Tbl_Emp_Leave_Apply.Emp_Leave_FromDate AS LeaveFromDate,          
            dbo.Tbl_Emp_Leave_Apply.Emp_Leave_ToDate AS LeaveToDate,          
            dbo.Tbl_Emp_Leave_Apply.Emp_Leave_Reason,           
            dbo.Tbl_Emp_Leave_Apply.Emp_Leave_Approve_Status AS [Approve Status],          
            dbo.Tbl_Leave_Type.Leave_Type_Name AS [LeaveType Name], 
            dbo.Tbl_Leave_Type.Leave_Color AS TypeColor,           
            dbo.Tbl_Employee.Employee_FName + '' '' + dbo.Tbl_Employee.Employee_LName AS FullName,      
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
        INNER JOIN dbo.Tbl_Leave_Type 
            ON dbo.Tbl_Emp_Leave_Apply.Emp_Leave_Type = dbo.Tbl_Leave_Type.Leave_Type_Id           
        INNER JOIN dbo.Tbl_Employee 
            ON dbo.Tbl_Emp_Leave_Apply.Employee_Id = dbo.Tbl_Employee.Employee_Id          
        WHERE 
            dbo.Tbl_Emp_Leave_Apply.Emp_Leave_Delete_Status = 0  
            AND dbo.Tbl_Employee.Employee_Status = 0
    END')
END;
