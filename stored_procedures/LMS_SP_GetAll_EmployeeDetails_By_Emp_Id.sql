IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_GetAll_EmployeeDetails_By_Emp_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LMS_SP_GetAll_EmployeeDetails_By_Emp_Id]  
            @Employee_Id BIGINT  
        AS  
        BEGIN  
            SET NOCOUNT ON;
            
            SELECT 
                Employee_FName + '' '' + Employee_LName AS EmployeeName
            FROM Tbl_Employee
            WHERE Employee_Id = @Employee_Id;
        END
    ')
END
