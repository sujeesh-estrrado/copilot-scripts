IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_All_Employee_Department]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Get_All_Employee_Department]     
        AS                
        BEGIN

        SELECT Tbl_Emp_Department.Dept_Id, Tbl_Emp_Department.Dept_Name
        FROM Tbl_Emp_Department

        END
    ')
END
