IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_get_notices_for_employee]')
    AND type = N'P'
)
BEGIN
    EXEC('
 CREATE PROCEDURE [dbo].[SP_get_notices_for_employee]  
   @employeeId BIGINT  
AS  
BEGIN  
    SET NOCOUNT ON;  

    DECLARE @DeptId BIGINT, @RoleId BIGINT, @EmployeeCreatedDate DATETIME;

    -- Step 1: Retrieve the Employee''s Department, Role, and Created Date
    SELECT 
        @DeptId = ISNULL(d.Dept_Id, 0),
        @RoleId = ISNULL(ra.Role_Id, 0),
        @EmployeeCreatedDate = eo.Created_Date  
    FROM dbo.Tbl_Employee AS e
    LEFT JOIN dbo.Tbl_Employee_Official AS eo ON e.Employee_Id = eo.Employee_Id
    LEFT JOIN dbo.Tbl_Emp_Department AS d ON eo.Department_Id = d.Dept_Id    
    LEFT JOIN dbo.Tbl_RoleAssignment AS ra ON e.Employee_Id = ra.employee_Id
    LEFT JOIN dbo.Tbl_Employee_User AS eu ON e.Employee_Id = eu.Employee_Id
    WHERE eu.User_Id = @employeeId;

    ---- You can add a SELECT here to return the DeptId and RoleId for debugging or external use
    --SELECT @DeptId AS DeptId, @RoleId AS RoleId;

    ---- Step 2: Retrieve Top 3 Notices for the Employee
    SELECT TOP 3 
        NB.Notice_Id,
        NB.Createdate,
        NB.Subject,
        NB.Annoncement,
        NB.Notice_Doc
    FROM tbl_Notice_Board NB
    WHERE 
        -- Check if Employee Created Date is NULL or filter by notices created after Employee Created Date
        (@EmployeeCreatedDate IS NULL OR CONVERT(DATE, NB.Createdate) >= CONVERT(DATE, @EmployeeCreatedDate))
        AND (
            -- Notices for all employees
            NB.Select_All_Employee = 1  
            -- Specific notices for the employee
            OR EXISTS (SELECT 1 FROM Notice_Employee_Maping WHERE Notice_Id = NB.Notice_Id AND Employee_Id = @employeeId)
            -- Notices for the employee''s department
            OR EXISTS (SELECT 1 FROM Notice_Department_Maping WHERE Notice_Id = NB.Notice_Id AND (Department_Id = @DeptId OR @DeptId IS NULL))
            -- Notices for the employee''s role
            OR EXISTS (SELECT 1 FROM Notice_Role_Maping WHERE Notice_Id = NB.Notice_Id AND (Role_Id = @RoleId OR @RoleId IS NULL))
        )
    ORDER BY NB.Notice_Id DESC;  -- Return most recent notices first

    SET NOCOUNT OFF;  
END;

    ')
END
GO
