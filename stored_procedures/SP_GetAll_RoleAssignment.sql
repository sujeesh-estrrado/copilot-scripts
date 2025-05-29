IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_RoleAssignment]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_GetAll_RoleAssignment]  
        AS  
        BEGIN  
        
            SELECT 
                RA.*, 
                R.role_Name, 
                CONCAT(E.Employee_FName, '' '', E.Employee_LName) AS [Employee Name]  
            FROM  
                [Tbl_RoleAssignment] RA  
            INNER JOIN 
                tbl_Role R ON RA.role_id = R.role_Id  
            INNER JOIN 
                Tbl_Employee E ON E.Employee_Id = RA.employee_id  
                   
            WHERE  
                RA.del_Status = 0 
                AND R.role_DeleteStatus = 0  
                AND E.Employee_Status = 0  
        
        END
    ')
END
