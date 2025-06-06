IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Asset_Stock_Transfer_Department]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Get_Asset_Stock_Transfer_Department]
        AS
        BEGIN
            SELECT DISTINCT 
                Department_Id, 
                (SELECT Dept_Name 
                 FROM dbo.Tbl_Emp_Department 
                 WHERE Dept_Id = Department_Id) AS Department_Name
            FROM dbo.Tbl_Asset_Department_Transfer
        END
    ')
END
